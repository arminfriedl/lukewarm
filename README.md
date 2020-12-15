[![Build Status](https://drone.friedl.net/api/badges/container/lukewarm/status.svg)](https://drone.friedl.net/container/lukewarm)

# Lukewarm and the Cool
One day [Cool](https://en.wikipedia.org/wiki/Cool_(programming_language))
compiled another
[`fact`](https://en.wikipedia.org/wiki/Cool_(programming_language)#Examples) and
suddenly got very sad. It was about its buddy
[Bodhi](https://www.bodhilinux.com/). Bodhi 1.4.0 (!!) was ancient and tired.
Its mirrors broke a long time ago an it just wanted to retire.

Cool on the other hand was still full of verve and vim, so it went looking for a
new companion. Soon enough Lukewarm entered its life. Lukewarm was a slick,
quick-witted, up-to-date container and they immediately got along well.

They lived happily ever after. The End.

![](luke.png)

_Totally unrelated image of a cowboy from [pngwing.com](https://www.pngwing.com/en/free-png-ydaxh)_

# Uhm?!
In short: If you are working through the [edX
Compilers](https://www.edx.org/course/compilers) course you probably want
Lukewarm instead of the Bodhi VM. It provides all the tools you need for
developing your Cool compiler in an up-to-date container image.

# Features
Lukewarm is tailored for working through the Cool assignments. It also has
several improvements over the provided [Bhodi](https://www.bodhilinux.com/) VM:
- All dependencies are pre-installed
- All `Cool` tools, scripts and binaries
- Grading scripts are pre-installed and can be executed directly (no workarounds
  like in the VM)
- Work locally with your favourite tools, then compile and submit from within
  the container
- Predictable and lightweight
- Use it with CI/CD
- It's based on an up-to-date debian image so you can `apt-get` what you need

# Where to get it
Lukewarm is published as a container image on
[https://hub.docker.com/](https://hub.docker.com/repository/docker/arminfriedl/lukewarm).
You can simply run it by:

```shell
docker run -it -v $PWD:/class arminfriedl/lukewarm
```

If you are using SELinux you may need to relabel the host folder so it is
accessible from the container:

```shell
docker run -it -v $PWD:/class:Z arminfriedl/lukewarm
```

You can find the repository the container image is built from on
https://git.friedl.net/container/lukewarm. [Drone](https://www.drone.io/) does
the heavy lifting and the build history can be found at
https://drone.friedl.net/container/lukewarm.

# How to use it
At first start this will set up all assignments in `/class` from the [course
distribution
tar](https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@student-dist.tar.gz).
If you mounted a host folder to `/class` you can modify the assignments on your
local machine and build them in the container.

The directory structure looks like this:

```
.
├── assignments
│   ├── ...
│   ├── PA3
│   ├── PA3J
│   ├── ...
├── bin
├── etc
├── examples
├── handouts
├── include
├── lib
└── src
```

Edit your assignments in the `./assignments/PA[0-9]J?` folder depending on
whether you want to work on the C++ or the Java version. Each `PA[0-9]J?` folder
contains a `grade.pl` script. For grading and retrieving your submission code
just execute `perl grade.pl` in the current assignment folder from within the
Lukewarm container.
