#!/bin/bash

# NOTE: This script should be executed in the directory of comnform.

export PATH="/home/$USER/.local/bin:$PATH"

# install github cli
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt-get install gh -y

if ! gh auth status >/dev/null 2>&1; then
	gh auth login
fi

# install useful packages
sudo apt-get install golang byobu neovim

# python
sudo apt-get install -y -qq software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt-get install -y -qq python3.13-full python3.13-dev

python3.13 -m venv .venv
. .venv/bin/activate

pip install -U pip
pip install -U wheel
pip install -U "jax[tpu]" -f https://storage.googleapis.com/jax-releases/libtpu_releases.html

python -c 'import jax; print(jax.devices())'

pip install -U "flax[all]"
pip install -U numpy
pip install -U matplotlib
pip install -U pandas
pip install -U huggingface
pip install -U datasets