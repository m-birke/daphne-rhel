FROM redhat/ubi8

RUN dnf update -y --refresh

# dev tools
RUN dnf install -y less nano git wget unzip file

# build deps for DAPHNE deps
RUN dnf install -y gcc gcc-c++ cmake clang ninja-build lld llvm pkg-config \
    gcc-gfortran patch libuuid-devel zlib-devel zstd redhat-lsb-core python3-devel

# build deps from epel
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf install -y lbzip2 ccache

# additional build deps for building DAPHNE itself
RUN dnf install -y java-11-openjdk-headless

WORKDIR /_work/
RUN git clone https://github.com/daphne-eu/daphne.git

WORKDIR /_work/daphne/
# limit no of jobs during build to avoid sig kill
RUN sed -i 's/cmake --build "$daphneBuildDir" --target "$target"/cmake --build "$daphneBuildDir" --target "$target" -- -j 4/g' build.sh
RUN ./build.sh

#    ca-certificates openssh-client \
#    libomp-dev  libpfm4-dev libssl-dev libxml2-dev \
#    build-essential python3-numpy python3-pandas \
#    vim rsync sudo iputils-ping virtualenv openssh-server iproute2 htop gpg-agent net-tools \
#    software-properties-common ca-certificates \
#    python3-pip python3-networkx graphviz-dev \
