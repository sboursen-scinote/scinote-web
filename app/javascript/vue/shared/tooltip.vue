<template>
  <div class="tooltip-container group relative flex justify-center items-center">
    <slot />
    <div
      class="absolute opacity-0 group-hover:opacity-100 bg-sn-black rounded-md p-3 w-[calc(100%+1.5rem)] left-0 max-w-[500px] top-full mt-[0.26rem] transition-opacity text-white shadow-tooltip"
    >
      {{ text }}
    </div>
    <span class="absolute opacity-0 group-hover:opacity-100 w-0 h-0 border-sn-black border-solid border-[0.5rem] border-t-0 border-x-transparent
                 top-[calc(100%-0.25rem)] left-[calc(50%+0.25rem)] transition-opacity"></span>
  </div>
</template>

<script>
export default {
  name: 'Tooltip',
  props: { 
    text: {
      type: String,
      required: true
    },
    classes: {
      type: String,
      default: ''
    }
  },
}
</script>
