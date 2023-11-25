#!/usr/bin/env bash

NPIPERELAY=npiperelay.exe

export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

start_ssh_agent() {
    if ! command -v $NPIPERELAY &> /dev/null; then
        echo "WARN: not found ${NPIPERELAY}" >&2
        return
    fi

    if ! ss -a | grep -q $SSH_AUTH_SOCK; then
        rm -f $SSH_AUTH_SOCK
        cat << 'EOF'
Prerequisite for ssh-agent with npiperelay below
- Start-Service ssh-agent on Windows
- ssh-add key on Windows
EOF

        (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"${NPIPERELAY} -ei -s -v //./pipe/openssh-ssh-agent",nofork &) &> /dev/null
    fi
}

stop_ssh_agent() {
    socat_pid=$(ss -ap |grep $SSH_AUTH_SOCK | sed -r 's/.+pid=([1-9][0-9]+).+/\1/')
    if test -z $socat_pid; then
        echo "Not found: agent socket."
        return
    fi
    echo "kill pid: ${socat_pid}"
    kill $socat_pid
}

start_ssh_agent
