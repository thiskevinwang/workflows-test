

if [[ tfc-agent-changelog/5.5.6 =~ ^tfc-agent-changelog/[0-9]+\.[0-9]+\.[0-9]+$ ]]
  then
    echo "::notice::Branch is valid — main"
  else
    echo "::error::Branch is invalid — main"
    exit 1
  fi