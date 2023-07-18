# LunarVim

> This is my personal settings on Vim.

## Why a distro?

Vim distros are opinionated settings fully loaded with many pre-configured plugins to deliver many ready to use functions out of the box.

I've used pure settings for years in the past, and updating them was really fun, however, I decided to switch to VsCode (yes, yew) for a while in order to get closer to my coworkers environment. In this period I was able to understand a little better what they like about it, and mostly, what they absolutely hate.

Even on VSCode, I've never abandoned Vim Motions, and while wondering how to reduce the transition barrier to suggest them to use Vim I stumbled on LunarVim, which has a configuration methodoly very close to a format that pleases me, and is also friendly to begginers comming from VSCode.

I'll probably won't use LVim forever, but I recognize it's value on bringing built-in features for people that doesn't have (yet) the same passion in configuring environments as I do.

### TL;DR

lvim has a low transition barrier for people that is not in love of config files (yet).

## Leader key

Despite the popularity of assigning `<space>` as leader key, my preference is for `\`.

After Apple launching MacBook with TouchBar, I saw many complaints on how awful it was to use a touchscreen button to switch modes. That lead me to an awesome discussion on reddit about the ESC key itself, which was not a thing since the beggining of computation.

Before winning the honnors to be a dedicated key, ESC was actually `^[` (`ctrl+[`). The fun part is that this combination was never replaced, for backwards compatibility, allowing a seamless transition.

Ok, but if my leader key is `\`, what ESC has to do with that? Having the constant usage of `[`, my pinky finger is always hovering that region, which makes `\` a very suitable key for frequent usage as well.

### TL;DR

I use `^[` instead of dedicated `<esc>` key which maked `\` a confortable alternative for leader key.

## Keybindings override

LunarVim has many preset keys on leader sequences from the start. I chose to override the minimum amout of Keybindings possible to avoid distancing too much of the what is documented on the distro website.

My alternative is appending new options to the sequences already existing, or using a "double leader" technique in order to get deeper commands without any conflict.

## NeoTree

I disabled lunarvim's default file explorer because I think NeoTree has better customizations. However, I only use it to peek at projects I'm not used to code frequently. Once I understand how things are organized, I only use telescope and fuzzy search.

A fixed side bar is too distracting for me, and I prefer to keep it closed. That is why I also prefer to use float window to navigate on the Tree instead of toggling it.

### TL;DR

I have ADHD, the least I have to be distracted with the better. NeoTree will remain closed.

