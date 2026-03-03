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
          { text: 'Gallery', link: '/gallery' },
        ]
      },
      {
        text: 'API Reference',
        items: [
          { text: 'Flux', link: '/api/Flux' },
          { text: 'Button', link: '/api/02_Button' },
          { text: 'Label', link: '/api/03_Label' },
          // add others here
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/vuejs/vitepress' }
    ]
  }
})
