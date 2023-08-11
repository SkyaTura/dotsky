<template lang="pug">
.theToolbar
  .wing.left
    slot(name="left")
  .notch
    slot(name="notch")
  .wing.right
    slot(name="right")
</template>

<style scoped>
.theToolbar {
  display: flex;
  align-items: stretch;
  color: white;
}

.wing {
  flex: 1 1;
  display: flex;
  align-items: center;
  gap: 8px;

  &.right {
    flex-direction: row-reverse;
  }
}

@keyframes breath {
  from {
    opacity: 0.5;
  }

  to {
    opacity: 1;
  }
}

.notch {
  flex: 0 0 220px;
  margin: 0px 2px;
  border-radius: 0 0 12px 12px;
  position: relative;

  &::before {
    border-radius: 0 0 12px 12px;
    content: "";
    position: absolute;
    width: 100%;
  }

  &.usingCamera {
    box-shadow: 0px 0px 4px 2px red;
    animation: breath 1s infinite alternate linear;
  }
}
</style>
