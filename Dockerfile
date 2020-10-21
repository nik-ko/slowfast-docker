FROM pytorch/pytorch:1.3-cuda10.1-cudnn7-runtime
ENV DEBIAN_FRONTEND=noninteractive 
ARG project_dir=slowfast

ARG new_user=pytorch
RUN useradd -ms /bin/bash $new_user
RUN addgroup $new_user sudo
RUN echo "$new_user:pt_user_slowfast_change!" | chpasswd
ENV PATH="/opt/conda/bin/:${PATH}"
RUN echo "export PATH=/opt/conda/bin/:${PATH}" >> /home/$new_user/.bashrc
RUN passwd --expire pytorch 


RUN apt-get update && apt-get upgrade -y \
 && apt-get install -y \
    openssh-server sudo \
    git \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    gcc \
    screen 
RUN pip install \
    numpy \
    opencv-python \
    tensorboard \
    moviepy \
    'git+https://github.com/facebookresearch/fvcore' \
    simplejson \
    sklearn \
    pandas \
    netron torchsummary jupyter jupyterlab  

WORKDIR /home/$new_user
RUN git clone https://github.com/facebookresearch/SlowFast.git ${project_dir}
WORKDIR /home/$new_user/$project_dir
RUN pip install torch torchvision==0.4.1 -f https://download.pytorch.org/whl/torch_stable.html 
RUN conda install av -c conda-forge \
&&     pip install -U torch==1.6.0 torchvision==0.4.1 cython \
&&    pip install -U 'git+https://github.com/facebookresearch/fvcore.git' \
&& pip install -U 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI' \
&&    git clone https://github.com/facebookresearch/detectron2 detectron2_repo \
&&    pip install -e detectron2_repo 
RUN python setup.py build develop

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
