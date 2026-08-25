// ANUI documentation theme
// Extends the default VitePress theme with ANUI brand colours.
import DefaultTheme from 'vitepress/theme'
import type { Theme } from 'vitepress'
import './custom.css'

export default {
  extends: DefaultTheme
} satisfies Theme
