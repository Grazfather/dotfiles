FROM alpine:latest

# Needed for dotfiles install
RUN apk add --no-cache neovim vim git

# Needed to install babashka itself
RUN apk add --no-cache bash curl
RUN curl -sL https://raw.githubusercontent.com/babashka/babashka/master/install \
	| bash -s -- --static

COPY . /dotfiles
WORKDIR /dotfiles
