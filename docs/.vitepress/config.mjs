import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "Flux",
  description: "Fluid UI library for CC:Tweaked",
  base: '/GUILIBRARY/',
  vite: {
    assetsInclude: ['**/*.html']
  },

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
          { text: 'Flux Engine', link: '/api/modules/Flux' },
          { text: 'Frame', link: '/api/modules/Frame' },
          { text: 'Button', link: '/api/modules/Button' },
          { text: 'Label', link: '/api/modules/Label' },
          { text: 'Dropdown', link: '/api/modules/Dropdown' },
          { text: 'Input', link: '/api/modules/Input' },
          { text: 'ProgressBar', link: '/api/modules/ProgressBar' },
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/Da5h1n/GUILIBRARY' }
    ]
  }
})