#!/bin/bash
# Clean up dangling (unused) docker images to save disk space on a remote host
# via ssh
#
# Copyright (c) 2016-2018, Yan Li <yanli@tuneup.ai>,
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Yan Li nor the names of other contributors
#       may be used to endorse or promote products derived from this
#       software without specific prior written permission.
#
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL YAN LI BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
set -e -u

if [ $# -ne 1 ]; then
    cat<<EOF
Clean up dangling (unused) docker images to save disk space on a remote host
via ssh

Usage: $0 host

Sample: $0 root@my-web-server.com

EOF
    exit 2
fi


HOST=$1
ssh $1 "$( cat<<EOT
docker images -f "dangling=true" -q >/tmp/di
if [ \$(cat /tmp/di | wc -l) -gt 0 ]; then
    cat /tmp/di | xargs docker rmi
fi
EOT
)"
