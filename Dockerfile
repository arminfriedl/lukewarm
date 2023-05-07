FROM debian:buster

# Prepare image and install dependencies
ENV LANG=C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    flex bison build-essential \
    csh libxaw7-dev wget \
    libc6-i386 default-jdk

RUN mkdir -p /tmp/build
COPY . /tmp/build

# Install student dist

# Note that this is _not_ what is in the `/usr/class/cs143` subdirectory in the
# VM! The `cs143` contains make files that generate the assignments in an
# arbitrary folder from skeleton files. Essentially this step was already done
# in the `student-dist.tar.gz`. The assignments just have to be completed and
# submitted in the respective /class/assignments/PA* subdirectories.

# Prepare the immutable distribution
RUN mkdir -p /usr/class \
  && wget https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@student-dist.tar.gz -P /tmp \
  && tar xzf "/tmp/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@student-dist.tar.gz" -C /usr/class
ENV PATH=/usr/class/bin:$PATH

# Download submission scripts
RUN wget -O - https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@pa1-grading.pl \
  | tee /usr/class/assignments/PA2J/grade.pl /usr/class/assignments/PA2/grade.pl > /dev/null

RUN wget -O - https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@pa2-grading.pl \
  | tee /usr/class/assignments/PA3J/grade.pl /usr/class/assignments/PA3/grade.pl > /dev/null

RUN wget -O - https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@pa3-grading.pl \
  | tee /usr/class/assignments/PA4J/grade.pl /usr/class/assignments/PA4/grade.pl > /dev/null

RUN wget -O - https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@pa4-grading.pl \
  | tee /usr/class/assignments/PA5J/grade.pl /usr/class/assignments/PA5/grade.pl > /dev/null

# Download additional resources to `class/handouts`. We scrape the whole
# websites every time we build the container. On the other hand they could just
# provide the resources in the course ¯\_(ツ)_/¯

# Move the handouts in the student-dist.tar.gz to edx subfolder
RUN mkdir -p /usr/class/handouts/edx \
  && cd /usr/class/handouts \
  && mv *.pdf edx

# Download cs143 resources. This contains e.g. latex templates for the assignments, previous finals
# https://web.stanford.edu/class/cs143/
RUN mkdir -p /usr/class/handouts/cs143 \
  && cd /usr/class/handouts/cs143 \
  && wget -r -k -l1 https://web.stanford.edu/class/cs143/ \
  && mv web.stanford.edu/class/cs143/* . && rm -fR web.stanford.edu

# Download openclassroom resources. this contains e.g. the annotated video slides.
# We are downloading the directory listing from
# http://openclassroom.stanford.edu/MainFolder/courses/Compilers/docs
# here, so we can use mirror (-m) without parents (-np) here.
# see also: http://openclassroom.stanford.edu/MainFolder/CoursePage.php?course=Compilers
RUN mkdir -p /usr/class/handouts/openclassroom \
  && cd /usr/class/handouts/openclassroom \
  && wget -np -m http://openclassroom.stanford.edu/MainFolder/courses/Compilers/docs/ \
  && mv openclassroom.stanford.edu/MainFolder/courses/Compilers/docs/* . && rm -fR openclassroom.stanford.edu

# Patch tar arguments in submission scripts
# We add -o to tar command since --preserve-permissions and --same-owner
# are default in tar for superuser. Since we are running as root
# in the container this messes up ownership of the `grading` folders
# created by the `grade.pl` scripts
RUN sed -i 's/-zx/-ozx/g' \
  /usr/class/assignments/PA2J/grade.pl /usr/class/assignments/PA2/grade.pl \
  /usr/class/assignments/PA3J/grade.pl /usr/class/assignments/PA3/grade.pl \
  /usr/class/assignments/PA4J/grade.pl /usr/class/assignments/PA4/grade.pl \
  /usr/class/assignments/PA5J/grade.pl /usr/class/assignments/PA5/grade.pl

# Patch cool.flex, cool.y in submission folder
# This is a hack to
#   a) satisfy the cool compiler which expects yylex to be named cool_yylex
#   b) satisfy libfl > 2.5.39 which expects a yylex symbol
#   c) fix mangling errors of yylex when compiled with a c++ compiler
#   d) be as non-invasive as possible to the existing assignment code
RUN patch -u /usr/class/assignments/PA2/cool.flex -i /tmp/build/cool.flex.patch \
    && patch -u /usr/class/assignments/PA3/cool.y -i /tmp/build/cool.y.patch \
    && patch -u /usr/class/assignments/PA4/Makefile -i /tmp/build/Makefile.patch \
    && patch -u /usr/class/assignments/PA5/Makefile -i /tmp/build/Makefile.patch

# Setup working directory
RUN mkdir -p /class
WORKDIR /class

# Run entrypoint to connect working directory to mounted host volume. This
# copies files to the (potentially host-mounted) volume, s.t. files can be
# edited on the host and are also visible in the container.
COPY entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["/bin/bash"]
