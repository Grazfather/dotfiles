#!/usr/bin/env python3
import os
import sys
import shutil
import re
import argparse
import subprocess
from pathlib import Path
from dataclasses import dataclass, field
from typing import Callable, List, Dict, Optional, Set

# --- Configuration & State ---

DOTFILES_DIR = Path(__file__).parent.resolve()
HOME_DIR = Path.home()
DRY_RUN = False
IS_MAC = sys.platform == "darwin"

SYMLINKS = {
    "vim": [("vim", None), ("vimrc", None)],
    "bash": [("bash_aliases", None)],
    "git": [("git/", ".config/git/")],
    "tmux": [("tmux.conf", None)],
    "spacehammer": [("spacehammer", None)],
    "wezterm": [("wezterm.lua", None)],
    "ghostty": [("ghostty/", ".config/ghostty/")],
    "karabiner": [("karabiner", ".config/karabiner/")],
    "starship": [("starship.toml", ".config/starship.toml")],
    "nvim": [("nvim/", ".config/nvim/")],
    "vscode": [("vscodesettings.json", "Library/Application Support/Code/User/settings.json")],
}

# --- ANSI Colors ---
class Colors:
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    ENDC = '\033[0m'


@dataclass
class Task:
    name: str
    func: Callable
    depends_on: List[str] = field(default_factory=list)
    description: str = ""
    selected: bool = True  # Whether it should run by default

TASKS: Dict[str, Task] = {}


def task(name: str, depends_on: Optional[List[str]] = None, description: str = "", default: bool = True):
    def decorator(func: Callable):
        TASKS[name] = Task(
            name=name,
            func=func,
            depends_on=depends_on or [],
            description=description,
            selected=default
        )
        return func
    return decorator

# --- Utilities ---

def log_info(*args): print(f"{Colors.BLUE}[*]{Colors.ENDC}", *args)
def log_warn(*args): print(f"{Colors.YELLOW}[!]{Colors.ENDC}", *args)
def log_error(*args): print(f"{Colors.RED}[✗]{Colors.ENDC}", *args)
def log_success(*args): print(f"{Colors.GREEN}[✓]{Colors.ENDC}", *args)


def file_contains(filepath: Path, substring: str) -> bool:
    if not filepath.exists():
        return False
    try:
        content = filepath.read_text()
        return substring in content
    except Exception as e:
        return False


def append_if_missing(filepath: Path, content: str, compare_string: str):
    if not file_contains(filepath, compare_string):
        if DRY_RUN:
            log_info(f"[DRY-RUN] Would append '{compare_string}' to {filepath}")
        else:
            with open(filepath, 'a') as f:
                f.write(content + "\n")
            log_info(f"Appended {compare_string} to {filepath}")
    else:
        log_warn(f"{compare_string} already in {filepath}")


def create_symlinks(links: List[tuple]):
    for src_str, dst_str in links:
        src = DOTFILES_DIR / src_str
        dst_name = dst_str if dst_str else f".{src_str.rstrip('/')}"
        dst = HOME_DIR / dst_name

        if dst.is_symlink() and os.readlink(str(dst)) == str(src):
            log_warn(f"Symlink already correct: {src} -> {dst}")
            continue

        if dst.exists() or dst.is_symlink():
            backup = dst.with_suffix(".bak")
            if DRY_RUN:
                log_info(f"[DRY-RUN] Would backup {dst} to {backup}")
            else:
                log_info(f"Backing up {dst} to {backup}")
                dst.parent.mkdir(parents=True, exist_ok=True)
                if backup.exists() or backup.is_symlink():
                    if backup.is_dir() and not backup.is_symlink():
                        shutil.rmtree(backup)
                    else:
                        backup.unlink()
                if dst.is_symlink():
                    dst.rename(backup)
                else:
                    shutil.move(str(dst), str(backup))

        if DRY_RUN:
            log_info(f"[DRY-RUN] Would symlink {src} -> {dst}")
        else:
            log_info(f"Symlinking {src} -> {dst}")
            dst.parent.mkdir(parents=True, exist_ok=True)
            try:
                dst.symlink_to(src)
            except FileExistsError:
                log_warn(f"Symlink {dst} already exists")

# --- Tasks ---

# Dynamically generate a symlink task for each group
for group_name, links in SYMLINKS.items():
    # Only select Mac-specific tasks by default if on Mac
    is_mac_only = group_name in ["karabiner", "vscode"]
    default_selected = True if not is_mac_only else IS_MAC

    @task(f"symlink-{group_name}", description=f"Create symlinks for {group_name}", default=default_selected)
    def symlink_task(links=links):
        create_symlinks(links)


@task("bash-aliases", depends_on=["symlink-bash"], description="Install bash aliases")
def run_bash_aliases():
    bashrc = HOME_DIR / ".bashrc"
    append_if_missing(bashrc, "\n[ -f $HOME/.bash_aliases ] && source $HOME/.bash_aliases", ".bash_aliases")
    append_if_missing(bashrc, "\n[ -f $HOME/.bash_aliases_local ] && source $HOME/.bash_aliases_local", ".bash_aliases_local")


@task("set-path", description="Add dotfiles bin to PATH")
def run_set_path():
    bashrc = HOME_DIR / ".bashrc"
    bin_path = DOTFILES_DIR / "bin"
    content = f"\n# Add dotfiles bin to PATH\nexport PATH=$PATH:{bin_path}"
    append_if_missing(bashrc, content, str(bin_path))


@task("vim-plugins", depends_on=["symlink-vim"], description="Install vim plugins", default=False)
def run_vim_plugins():
    if shutil.which("vim") is None:
        log_error("vim executable not found in PATH. Skipping vim plugins.")
        return
    if DRY_RUN:
        log_info("[DRY-RUN] Would install vim plugins")
        return
    log_info("Installing vim plugins...")
    subprocess.run(["vim", "+PlugInstall --sync", "+qa"])


@task("nvim-plugins", depends_on=["symlink-nvim"], description="Install neovim plugins", default=False)
def run_nvim_plugins():
    if shutil.which("nvim") is None:
        log_error("nvim executable not found in PATH. Skipping neovim plugins.")
        return
    if DRY_RUN:
        log_info("[DRY-RUN] Would install neovim plugins")
        return
    log_info("Installing neovim plugins...")
    subprocess.run(["nvim", "+qa"])


@task("nvim-light", description="Enable NVIM_LIGHT in bashrc", default=False)
def run_nvim_light():
    bashrc = HOME_DIR / ".bashrc"
    content = "\n# Enable Neovim light mode\nexport NVIM_LIGHT=1"
    append_if_missing(bashrc, content, "NVIM_LIGHT=1")


# --- Engine ---

PROFILES = {
    "desktop": ["symlink-vim", "symlink-bash", "symlink-git", "symlink-tmux", "symlink-spacehammer", "symlink-wezterm", "symlink-ghostty", "symlink-karabiner", "symlink-starship", "symlink-nvim", "symlink-vscode", "bash-aliases", "set-path"],
    "vps": ["symlink-vim", "symlink-bash", "symlink-git", "symlink-tmux", "symlink-nvim", "symlink-starship", "bash-aliases", "set-path"],
    "none": []
}


def set_task_state(task_name: str, state: bool):
    if task_name not in TASKS: return
    t = TASKS[task_name]
    if t.selected == state: return

    t.selected = state

    if state:
        # toggled on: ensure all dependencies are also on
        for dep in t.depends_on:
            set_task_state(dep, True)
    else:
        # toggled off: ensure all tasks depending on this are also off
        for other_name, other_task in TASKS.items():
            if task_name in other_task.depends_on:
                set_task_state(other_name, False)

def apply_profile(profile_name: str):
    if profile_name not in PROFILES:
        log_error(f"Profile {profile_name} not found.")
        return
    for t_name in TASKS:
        TASKS[t_name].selected = False

    for t_name in PROFILES[profile_name]:
        set_task_state(t_name, True)
    log_info(f"Applied profile: {profile_name}")


def get_task_order(selected_tasks: Set[str]) -> List[str]:
    # Topological sort for selected tasks and their dependencies
    order = []
    visited: Set[str] = set()
    visiting: Set[str] = set()

    def visit(task_name: str):
        if task_name in visited: return
        if task_name in visiting:
            raise ValueError(f"Circular dependency detected: {task_name}")

        visiting.add(task_name)
        if task_name in TASKS:
            for dep in TASKS[task_name].depends_on:
                visit(dep)
        visiting.remove(task_name)
        visited.add(task_name)
        order.append(task_name)

    # Automatically visit dependencies of selected tasks
    to_visit = set(selected_tasks)
    for t in list(to_visit):
        visit(t)

    return [t for t in order if t in TASKS]


def draw_menu():
    print(f"\n{Colors.BLUE}{'='*40}{Colors.ENDC}")
    print(f" {Colors.GREEN}Dotfiles Installer{Colors.ENDC} " + (f"{Colors.YELLOW}[DRY RUN ACTIVE]{Colors.ENDC}" if DRY_RUN else ""))
    print(f"{Colors.BLUE}{'='*40}{Colors.ENDC}")

    task_keys = list(TASKS.keys())
    for i, key in enumerate(task_keys):
        t = TASKS[key]
        mark = f"{Colors.GREEN}x{Colors.ENDC}" if t.selected else " "
        print(f" [{mark}] {i+1}. {key} - {t.description}")
        if t.depends_on:
            print(f"         {Colors.YELLOW}(depends on: {', '.join(t.depends_on)}){Colors.ENDC}")

    print("\nCommands:")
    print(" <number> : Toggle selection")
    print(" 'p'      : Cycle profile (desktop / vps / none)")
    print(" 'd'      : Toggle Dry-Run mode")
    print(" 'a'      : Select all")
    print(" 'n'      : Select none")
    print(" 'r'      : Run selected tasks")
    print(" 'q'      : Quit")

    return task_keys


def execute_tasks(selected: Set[str]):
    try:
        order = get_task_order(selected)
        print("\nExecution Order:", " -> ".join(order))

        if not DRY_RUN:
            confirm = input("Proceed? [y/N]: ")
            if confirm.lower() != 'y':
                return False

        for t_name in order:
            print(f"\n--- Running: {t_name} ---")
            TASKS[t_name].func()

        if DRY_RUN:
            log_success("Finished DRY RUN of selected tasks.")
            return False # don't exit menu on dry run
        else:
            log_success("Finished running selected tasks.")
            return True # exit menu
    except Exception as e:
        log_error(f"Error during execution: {e}")
        return False


def interactive_main():
    global DRY_RUN
    profiles_list = list(PROFILES.keys())
    current_profile_idx = 0

    while True:
        keys = draw_menu()
        choice = input("\nSelect > ").strip().lower()

        if choice == 'q':
            break
        elif choice == 'a':
            for t_name in TASKS: set_task_state(t_name, True)
        elif choice == 'n':
            for t_name in TASKS: set_task_state(t_name, False)
        elif choice == 'd':
            DRY_RUN = not DRY_RUN
        elif choice == 'p':
            current_profile_idx = (current_profile_idx + 1) % len(profiles_list)
            apply_profile(profiles_list[current_profile_idx])
        elif choice == 'r':
            selected = {k for k, v in TASKS.items() if v.selected}
            if not selected:
                print("No tasks selected!")
                continue

            if execute_tasks(selected):
                break
        elif choice.isdigit():
            idx = int(choice) - 1
            if 0 <= idx < len(keys):
                t_name = keys[idx]
                set_task_state(t_name, not TASKS[t_name].selected)
        else:
            print("Invalid input.")


def cli_main():
    global DRY_RUN

    # Enforce default selection dependencies
    for t_name in list(TASKS.keys()):
        if TASKS[t_name].selected:
            set_task_state(t_name, True)

    parser = argparse.ArgumentParser(description="Dotfiles Installer")
    parser.add_argument("--unattended", action="store_true", help="Run automatically without interactive menu against current selections")
    parser.add_argument("--profile", type=str, choices=PROFILES.keys(), help="Apply a specific profile before running")
    parser.add_argument("--dry-run", action="store_true", help="Don't make any actual changes")
    parser.add_argument("--all", action="store_true", help="Select all tasks")

    args = parser.parse_args()

    if args.dry_run:
        DRY_RUN = True

    if args.profile:
        apply_profile(args.profile)

    if args.all:
        for t_name in TASKS: set_task_state(t_name, True)

    if args.unattended or args.profile or args.all or args.dry_run:
        # Headless execution
        selected = {k for k, v in TASKS.items() if v.selected}
        if not selected:
            log_warn("No tasks selected for unattended run!")
            return

        log_info(f"Running in unattended mode... (Dry run: {DRY_RUN})")
        execute_tasks(selected)
    else:
        # Fallback to interactive mode if no CLI args provided
        interactive_main()


if __name__ == "__main__":
    try:
        cli_main()
    except KeyboardInterrupt:
        print("\nExiting...")
