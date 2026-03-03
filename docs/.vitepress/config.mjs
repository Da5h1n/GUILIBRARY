import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Flux",
  description: "Fluid UI library for CC:Tweaked",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Examples', link: '/markdown-examples' }
    ],

    sidebar: [
      {
        text: 'Introduction',
        items: [
          { text: 'Getting Started', link: '/' },
        ]
      },
      {
        text: 'API Reference',
        items: [
          { text: 'Flux Engine', link: '/api/modules/Flux' },
          { text: 'Button', link: '/api/modules/Button' },
          { text: 'Label', link: '/api/modules/Label' },
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/vuejs/vitepress' }
    ]
  }
})
