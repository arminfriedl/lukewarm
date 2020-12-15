# Lukewarm and the Cool
One day [Cool](https://en.wikipedia.org/wiki/Cool_(programming_language))
compiled another
[`fact`](https://en.wikipedia.org/wiki/Cool_(programming_language)#Examples) and
suddenly got very sad. It was about its buddy
[Bodhi](https://www.bodhilinux.com/). Bodhi 1.4.0 (!!) was ancient and tired.
Its mirrors broke a long time ago an it just wanted to retire.

Cool on the other hand was still full of verve and vim. So it went looking for a
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

# Usage

```shell
docker run -it -v $PWD:/class arminfriedl/lukewarm
```

At first start this will set up all assignments in `$PWD`.
