#!/usr/bin/env bash

# Install a bash terminal theme similar to the reference screenshot:
# black background, light foreground, red user/host prompt, blue path and
# blue directory names in ls output.

set -euo pipefail

BASHRC="${HOME}/.bashrc"
START_MARK="# >>> pcie5_phy_terminal_theme >>>"
END_MARK="# <<< pcie5_phy_terminal_theme <<<"

if [[ ! -f "${BASHRC}" ]]; then
  touch "${BASHRC}"
fi

tmp_file="$(mktemp)"
awk -v start="${START_MARK}" -v end="${END_MARK}" '
  $0 == start {skip=1; next}
  $0 == end {skip=0; next}
  skip != 1 {print}
' "${BASHRC}" > "${tmp_file}"

cat >> "${tmp_file}" <<'THEME'
# >>> pcie5_phy_terminal_theme >>>
# PCIe5 PHY project terminal theme. Reload with: source ~/.bashrc
if [[ $- == *i* ]]; then
  # Ask compatible terminal emulators for a black background and light text.
  printf '\033]10;#f2f2f2\007'
  printf '\033]11;#000000\007'

  # Prompt format:
  #   user@host  : bright red
  #   current dir: bright blue
  #   typed text : light gray/white
  PS1='\[\e[1;31m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

  alias ls='ls --color=auto'
  alias ll='ls -l --color=auto'
  alias la='ls -la --color=auto'

  export CLICOLOR=1
  export LS_COLORS='di=01;34:ln=01;36:so=01;35:pi=33:ex=01;32:bd=01;33:cd=01;33:su=37;41:sg=30;43:tw=30;42:ow=34;42:*.tar=01;31:*.tgz=01;31:*.zip=01;31:*.gz=01;31:*.bz2=01;31:*.xz=01;31'
fi
# <<< pcie5_phy_terminal_theme <<<
THEME

mv "${tmp_file}" "${BASHRC}"

echo "Terminal theme installed into ${BASHRC}"
echo "Run 'source ~/.bashrc' or reopen the terminal to apply it."
