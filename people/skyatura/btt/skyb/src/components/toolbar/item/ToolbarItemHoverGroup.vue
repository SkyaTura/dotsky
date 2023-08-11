<template lang="pug">
ToolbarItem.itemGroup
  ToolbarItem.itemGroup-idle
    slot(name="idle")
  ToolbarItem.itemGroup-hover
    slot(name="hover")
</template>

<style scoped>
.itemGroup {
  position: relative;
  display: flex;
  align-items: stretch;
  justify-content: center;
  & > * {
    transition: all .6s;
    height: 100%;
    top: 0;
  }
  &:hover > * {
    transition: all .3s;
  }
  & > *:not(.itemGroup-idle) {
    position: absolute;
  }
  &:hover > .itemGroup-idle,
  &:not(:hover) > .itemGroup-hover {
    opacity: 0;
    transform: scale(0.5);
  }

}
</style>
