# syntax=docker/dockerfile:1
FROM codercom/enterprise-base:ubuntu

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    jq \
    unzip \
    gzip \
    openssh-client \
    build-essential \
    bash \
  && rm -rf /var/lib/apt/lists/*

# --- Install mise (runtime manager) ---
RUN curl -fsSL https://mise.run | sh \
  && install -m 0755 /root/.local/bin/mise /usr/local/bin/mise \
  && rm -rf /root/.local

# Shell activation for terminals
RUN echo '\n# mise (runtime manager)\nif command -v mise >/dev/null 2>&1; then eval "$(mise activate bash)"; fi\n' >> /etc/bash.bashrc

# --- BMAD stack tooling (copied in) ---
ENV BMAD_STACK_DIR=/opt/bmad/stacks

COPY bmad/bin/bmad-stack /usr/local/bin/bmad-stack
RUN chmod 0755 /usr/local/bin/bmad-stack \
 && sed -i 's/\r$//' /usr/local/bin/bmad-stack

COPY bmad/stacks/ /opt/bmad/stacks/
RUN chmod -R a+rX /opt/bmad/stacks

USER coder
WORKDIR /home/coder