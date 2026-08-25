import { defineConfig, type DefaultTheme } from 'vitepress'

// ---------------------------------------------------------------------------
// Project constants
// ---------------------------------------------------------------------------
const VERSION = 'v1.0.267'
const GITHUB = 'https://github.com/ANHub-Script/ANUI'
const DOCS_REPO = 'https://github.com/ANHub-Script/ANUI'
const DISCORD = 'https://discord.gg/bUkCZvmrpH'
const YOUTUBE = 'https://www.youtube.com/@ANHubRoblox'

// Custom Discord social icon (simple-icons path)
const discordIcon = {
  svg: '<svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><title>Discord</title><path d="M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z"/></svg>'
}

// A tiny translation helper: pass the English + Indonesian strings, the active
// locale picks the right one. Keeps EN and ID nav/sidebars perfectly in sync.
type T = (en: string, id: string) => string
const EN: T = (en) => en
const ID: T = (_en, id) => id

// ---------------------------------------------------------------------------
// Navbar
// ---------------------------------------------------------------------------
function nav(p: string, t: T): DefaultTheme.NavItem[] {
  return [
    { text: t('Guide', 'Panduan'), link: `${p}/guide/introduction`, activeMatch: `${p}/guide/` },
    { text: t('Elements', 'Elemen'), link: `${p}/elements/`, activeMatch: `${p}/elements/` },
    { text: t('Features', 'Fitur'), link: `${p}/features/notifications`, activeMatch: `${p}/features/` },
    { text: t('Examples', 'Contoh'), link: `${p}/examples/`, activeMatch: `${p}/examples/` },
    { text: t('Reference', 'Referensi'), link: `${p}/api/`, activeMatch: `${p}/api/` },
    {
      text: VERSION,
      items: [
        { text: t('Release Notes', 'Catatan Rilis'), link: `${GITHUB}/releases` },
        { text: 'GitHub', link: GITHUB },
        { text: 'Discord', link: DISCORD },
        { text: 'YouTube', link: YOUTUBE }
      ]
    }
  ]
}

// ---------------------------------------------------------------------------
// Sidebar (shared across all doc pages of a locale)
// ---------------------------------------------------------------------------
function sidebar(p: string, t: T): DefaultTheme.SidebarItem[] {
  return [
    {
      text: t('Getting Started', 'Memulai'),
      collapsed: false,
      items: [
        { text: t('Introduction', 'Pengenalan'), link: `${p}/guide/introduction` },
        { text: t('Installation', 'Instalasi'), link: `${p}/guide/installation` },
        { text: t('Quick Start', 'Mulai Cepat'), link: `${p}/guide/getting-started` },
        { text: t('Window Configuration', 'Konfigurasi Window'), link: `${p}/guide/window-configuration` },
        { text: t('Tabs & Sections', 'Tab & Section'), link: `${p}/guide/tabs-and-sections` }
      ]
    },
    {
      text: t('Elements', 'Elemen'),
      collapsed: false,
      items: [
        { text: t('Overview', 'Ikhtisar'), link: `${p}/elements/` },
        { text: 'Button', link: `${p}/elements/button` },
        { text: 'Toggle', link: `${p}/elements/toggle` },
        { text: 'Slider', link: `${p}/elements/slider` },
        { text: 'Dropdown', link: `${p}/elements/dropdown` },
        { text: 'Input', link: `${p}/elements/input` },
        { text: 'Keybind', link: `${p}/elements/keybind` },
        { text: 'Colorpicker', link: `${p}/elements/colorpicker` },
        { text: 'Paragraph', link: `${p}/elements/paragraph` },
        { text: 'Code', link: `${p}/elements/code` },
        { text: 'Section', link: `${p}/elements/section` },
        { text: 'Divider', link: `${p}/elements/divider` },
        { text: 'Space', link: `${p}/elements/space` },
        { text: 'Image', link: `${p}/elements/image` },
        { text: 'Group', link: `${p}/elements/group` },
        { text: 'Category', link: `${p}/elements/category` }
      ]
    },
    {
      text: t('Features', 'Fitur'),
      collapsed: false,
      items: [
        { text: t('Notifications', 'Notifikasi'), link: `${p}/features/notifications` },
        { text: t('Dialogs & Popups', 'Dialog & Popup'), link: `${p}/features/dialogs-and-popups` },
        { text: t('Config & Flags', 'Konfigurasi & Flag'), link: `${p}/features/config-and-flags` },
        { text: t('Key System', 'Sistem Key'), link: `${p}/features/key-system` },
        { text: t('Themes & Appearance', 'Tema & Tampilan'), link: `${p}/features/themes` },
        { text: t('Localization', 'Lokalisasi'), link: `${p}/features/localization` },
        { text: t('Scheduler & Loops', 'Scheduler & Loop'), link: `${p}/features/scheduler` },
        { text: t('Open Button', 'Tombol Buka'), link: `${p}/features/open-button` }
      ]
    },
    {
      text: t('Examples', 'Contoh'),
      collapsed: false,
      items: [
        { text: t('Overview', 'Ikhtisar'), link: `${p}/examples/` },
        { text: t('Basic Menu', 'Menu Dasar'), link: `${p}/examples/basic-menu` },
        { text: t('Config System', 'Sistem Konfigurasi'), link: `${p}/examples/config-system` },
        { text: t('Category Pages', 'Halaman Kategori'), link: `${p}/examples/category-pages` }
      ]
    },
    {
      text: t('Reference', 'Referensi'),
      collapsed: false,
      items: [
        { text: t('API Cheatsheet', 'Ringkasan API'), link: `${p}/api/` }
      ]
    }
  ]
}

// ---------------------------------------------------------------------------
// Config
// ---------------------------------------------------------------------------
export default defineConfig({
  title: 'ANUI',
  description: 'ANUI — a modern, feature-rich UI library for Roblox script executors.',
  base: '/ANUI/',
  cleanUrls: true,
  lastUpdated: true,
  ignoreDeadLinks: true,

  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: '/ANUI/logo.svg' }],
    ['meta', { name: 'theme-color', content: '#40c9ff' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:title', content: 'ANUI — Advanced Roblox UI Library' }],
    ['meta', { property: 'og:description', content: 'A modern, feature-rich UI library for Roblox script executors.' }]
  ],

  themeConfig: {
    logo: '/logo.svg',
    search: {
      provider: 'local',
      options: {
        locales: {
          id: {
            translations: {
              button: { buttonText: 'Cari', buttonAriaLabel: 'Cari' },
              modal: {
                displayDetails: 'Tampilkan detail',
                resetButtonTitle: 'Reset pencarian',
                noResultsText: 'Tidak ada hasil untuk',
                footer: { selectText: 'untuk memilih', navigateText: 'untuk berpindah', closeText: 'untuk menutup' }
              }
            }
          }
        }
      }
    },
    socialLinks: [
      { icon: 'github', link: GITHUB },
      { icon: discordIcon, link: DISCORD }
    ]
  },

  locales: {
    root: {
      label: 'English',
      lang: 'en',
      themeConfig: {
        nav: nav('', EN),
        sidebar: sidebar('', EN),
        editLink: {
          pattern: `${DOCS_REPO}/edit/main/docs/:path`,
          text: 'Edit this page on GitHub'
        },
        outline: { level: [2, 3], label: 'On this page' },
        docFooter: { prev: 'Previous', next: 'Next' },
        lastUpdated: { text: 'Last updated' },
        footer: {
          message: 'Released under the MIT License.',
          copyright: 'Copyright © 2024–present ANHub-Script · Based on WindUI by Footagesus'
        }
      }
    },
    id: {
      label: 'Bahasa Indonesia',
      lang: 'id',
      link: '/id/',
      themeConfig: {
        nav: nav('/id', ID),
        sidebar: sidebar('/id', ID),
        editLink: {
          pattern: `${DOCS_REPO}/edit/main/docs/:path`,
          text: 'Edit halaman ini di GitHub'
        },
        outline: { level: [2, 3], label: 'Di halaman ini' },
        docFooter: { prev: 'Sebelumnya', next: 'Berikutnya' },
        lastUpdated: { text: 'Terakhir diperbarui' },
        footer: {
          message: 'Dirilis di bawah Lisensi MIT.',
          copyright: 'Hak Cipta © 2024–sekarang ANHub-Script · Berbasis WindUI oleh Footagesus'
        }
      }
    }
  }
})
