import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "Flux",
  description: "Fluid UI library for CC:Tweaked",
  base: '/',

  themeConfig: {
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Guide', link: '/guides/getting-started' }
    ],

    sidebar: [
      {
        text: 'Introduction',
        items: [
          { text: 'Getting Started', link: '/guides/getting-started' },
        ]
      },
      {
        text: 'API Reference',
        items: [
          { text: 'Flux Engine', link: '/api/Flux' },
          { text: 'Frame', link: '/api/Frame' },
          { text: 'Button', link: '/api/Button' },
          { text: 'Label', link: '/api/Label' },
          { text: 'Dropdown', link: '/api/Dropdown' },
          { text: 'Input', link: '/api/Input' },
          { text: 'ProgressBar', link: '/api/ProgressBar' },
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/Da5h1n/GUILIBRARY' }
    ]
  }
})