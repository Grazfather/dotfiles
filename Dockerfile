FROM alpine:latest

# Needed for dotfiles install
RUN apk add --no-cache neovim vim git bash curl

RUN cat /etc/resolv.conf
RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb \
	&& dpkg -i ripgrep_12.1.1_amd64.deb

RUN curl -sL https://raw.githubusercontent.com/babashka/babashka/master/install \
	| bash -s -- --static

COPY . /dotfiles
WORKDIR /dotfiles
