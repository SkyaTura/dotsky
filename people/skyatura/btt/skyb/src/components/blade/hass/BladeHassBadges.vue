<script setup lang="ts">
</script>

<template lang="pug">
ToolbarItem.hassBadges
  .hack-icon.off 󰃞
  .hack-icon.mode 󰃟
  .hack-icon.zone 󰃠
</template>

<style scoped>
.hassBadges {
  display: flex;
  align-items: center;
  align-self: stretch;
  font-size: 12px;
  transition: all .3s;
  &:not(:hover) {
    opacity: 0;
    transform: scale(0.5);
  }
}
.hassBadges > * {
  padding: 0px 3px;
  margin: 0px 2px;
  cursor: pointer;
}
</style>
