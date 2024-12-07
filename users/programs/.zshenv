# Environment variables
. "/etc/profiles/per-user/arindamukawlas/etc/profile.d/hm-session-vars.sh"

# Only source this once
if [[ -z "$__HM_ZSH_SESS_VARS_SOURCED" ]]; then
  export __HM_ZSH_SESS_VARS_SOURCED=1
  
fi

export ZDOTDIR=$HOME/.config/zsh
