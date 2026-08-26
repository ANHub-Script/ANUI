import { defineConfig, type DefaultTheme } from 'vitepress'
import { readFileSync } from 'node:fs'
import { fileURLToPath } from 'node:url'

// ---------------------------------------------------------------------------
// Version — auto-synced from the root package.json
// ---------------------------------------------------------------------------
// Reads the library version so the navbar badge stays in sync every time
// `npm run build` bumps it. Runs at docs build time; the deploy workflow
// rebuilds on every push, so no manual edits are ever needed.
function readVersion(): string {
  try {
    const pkgPath = fileURLToPath(new URL('../../package.json', import.meta.url))
    const pkg = JSON.parse(readFileSync(pkgPath, 'utf-8'))
    return pkg.version ? `v${pkg.version}` : 'latest'
  } catch {
    return 'latest'
  }
}
const VERSION = readVersion()

// ---------------------------------------------------------------------------
// Project constants
// ---------------------------------------------------------------------------
const GITHUB = 'https://github.com/ANHub-Script/ANUI'
const DOCS_REPO = 'https://github.com/ANHub-Script/ANUI'
const DISCORD = 'https://discord.gg/qN47S3mKZA'
const YOUTUBE = 'https://www.youtube.com/@ANHubRoblox'

// Custom Discord social icon (simple-icons path)
const discordIcon = {
  svg: '<svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><title>Discord</title><path d="M20.317 4.3698a19.7913 19.7913 0 00-4.8851-1.5152.0741.0741 0 00-.0785.0371c-.211.3753-.4447.8648-.6083 1.2495-1.8447-.2762-3.68-.2762-5.4868 0-.1636-.3933-.4058-.8742-.6177-1.2495a.077.077 0 00-.0785-.037 19.7363 19.7363 0 00-4.8852 1.515.0699.0699 0 00-.0321.0277C.5334 9.0458-.319 13.5799.0992 18.0578a.0824.0824 0 00.0312.0561c2.0528 1.5076 4.0413 2.4228 5.9929 3.0294a.0777.0777 0 00.0842-.0276c.4616-.6304.8731-1.2952 1.226-1.9942a.076.076 0 00-.0416-.1057c-.6528-.2476-1.2743-.5495-1.8722-.8923a.077.077 0 01-.0076-.1277c.1258-.0943.2517-.1923.3718-.2914a.0743.0743 0 01.0776-.0105c3.9278 1.7933 8.18 1.7933 12.0614 0a.0739.0739 0 01.0785.0095c.1202.099.246.1981.3728.2924a.077.077 0 01-.0066.1276 12.2986 12.2986 0 01-1.873.8914.0766.0766 0 00-.0407.1067c.3604.698.7719 1.3628 1.225 1.9932a.076.076 0 00.0842.0286c1.961-.6067 3.9495-1.5219 6.0023-3.0294a.077.077 0 00.0313-.0552c.5004-5.177-.8382-9.6739-3.5485-13.6604a.061.061 0 00-.0312-.0286zM8.02 15.3312c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9555-2.4189 2.157-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.9555 2.4189-2.1569 2.4189zm7.9748 0c-1.1825 0-2.1569-1.0857-2.1569-2.419 0-1.3332.9554-2.4189 2.1569-2.4189 1.2108 0 2.1757 1.0952 2.1568 2.419 0 1.3332-.946 2.4189-2.1568 2.4189Z"/></svg>'
}

// ---------------------------------------------------------------------------
// i18n — one dictionary, five languages. Keeps every locale's nav/sidebar/UI
// perfectly in sync. Element names (Button, Toggle, …) are API identifiers and
// stay in English on purpose.
//
// To add a locale: add its code to `Lang`, add a translation to every UI entry
// below, then register it in `locales` at the bottom (plus a `searchTr` line).
// ---------------------------------------------------------------------------
type Lang = 'en' | 'id' | 'ja' | 'ru' | 'zh'
type Entry = Record<Lang, string>

const UI: Record<string, Entry> = {
  // Navbar
  guide: { en: 'Guide', id: 'Panduan', ja: 'ガイド', ru: 'Руководство', zh: '指南' },
  elements: { en: 'Elements', id: 'Elemen', ja: 'エレメント', ru: 'Элементы', zh: '组件' },
  features: { en: 'Features', id: 'Fitur', ja: '機能', ru: 'Возможности', zh: '功能' },
  examples: { en: 'Examples', id: 'Contoh', ja: 'サンプル', ru: 'Примеры', zh: '示例' },
  reference: { en: 'Reference', id: 'Referensi', ja: 'リファレンス', ru: 'Справочник', zh: '参考' },
  releaseNotes: { en: 'Release Notes', id: 'Catatan Rilis', ja: 'リリースノート', ru: 'Список изменений', zh: '更新日志' },

  // Sidebar groups
  gettingStarted: { en: 'Getting Started', id: 'Memulai', ja: '入門', ru: 'Начало работы', zh: '快速开始' },

  // Sidebar items
  introduction: { en: 'Introduction', id: 'Pengenalan', ja: 'はじめに', ru: 'Введение', zh: '简介' },
  installation: { en: 'Installation', id: 'Instalasi', ja: 'インストール', ru: 'Установка', zh: '安装' },
  quickStart: { en: 'Quick Start', id: 'Mulai Cepat', ja: 'クイックスタート', ru: 'Быстрый старт', zh: '快速上手' },
  windowConfig: { en: 'Window Configuration', id: 'Konfigurasi Window', ja: 'ウィンドウ設定', ru: 'Настройка окна', zh: '窗口配置' },
  tabsSections: { en: 'Tabs & Sections', id: 'Tab & Section', ja: 'タブとセクション', ru: 'Вкладки и разделы', zh: '标签页与分区' },
  overview: { en: 'Overview', id: 'Ikhtisar', ja: '概要', ru: 'Обзор', zh: '概览' },
  notifications: { en: 'Notifications', id: 'Notifikasi', ja: '通知', ru: 'Уведомления', zh: '通知' },
  dialogsPopups: { en: 'Dialogs & Popups', id: 'Dialog & Popup', ja: 'ダイアログとポップアップ', ru: 'Диалоги и всплывающие окна', zh: '对话框与弹窗' },
  configFlags: { en: 'Config & Flags', id: 'Konfigurasi & Flag', ja: '設定と Flag', ru: 'Конфигурация и флаги', zh: '配置与 Flag' },
  keySystem: { en: 'Key System', id: 'Sistem Key', ja: 'キーシステム', ru: 'Система ключей', zh: '密钥系统' },
  githubKeys: { en: 'GitHub Key System', id: 'Sistem Key GitHub', ja: 'GitHub キーシステム', ru: 'Ключи через GitHub', zh: 'GitHub 密钥系统' },
  themes: { en: 'Themes & Appearance', id: 'Tema & Tampilan', ja: 'テーマと外観', ru: 'Темы и оформление', zh: '主题与外观' },
  localization: { en: 'Localization', id: 'Lokalisasi', ja: 'ローカライズ', ru: 'Локализация', zh: '本地化' },
  scheduler: { en: 'Scheduler & Loops', id: 'Scheduler & Loop', ja: 'スケジューラーとループ', ru: 'Планировщик и циклы', zh: '调度器与循环' },
  openButton: { en: 'Open Button', id: 'Tombol Buka', ja: 'オープンボタン', ru: 'Кнопка открытия', zh: '打开按钮' },
  basicMenu: { en: 'Basic Menu', id: 'Menu Dasar', ja: '基本メニュー', ru: 'Базовое меню', zh: '基础菜单' },
  configSystem: { en: 'Config System', id: 'Sistem Konfigurasi', ja: '設定システム', ru: 'Система конфигурации', zh: '配置系统' },
  categoryPages: { en: 'Category Pages', id: 'Halaman Kategori', ja: 'カテゴリーページ', ru: 'Страницы категорий', zh: '分类页面' },
  apiCheatsheet: { en: 'API Cheatsheet', id: 'Ringkasan API', ja: 'API チートシート', ru: 'Шпаргалка по API', zh: 'API 速查表' },

  // Misc theme UI
  editLink: { en: 'Edit this page on GitHub', id: 'Edit halaman ini di GitHub', ja: 'このページを GitHub で編集', ru: 'Редактировать эту страницу на GitHub', zh: '在 GitHub 上编辑此页' },
  onThisPage: { en: 'On this page', id: 'Di halaman ini', ja: 'このページの内容', ru: 'На этой странице', zh: '本页目录' },
  prev: { en: 'Previous', id: 'Sebelumnya', ja: '前へ', ru: 'Назад', zh: '上一页' },
  next: { en: 'Next', id: 'Berikutnya', ja: '次へ', ru: 'Вперёд', zh: '下一页' },
  lastUpdated: { en: 'Last updated', id: 'Terakhir diperbarui', ja: '最終更新', ru: 'Последнее обновление', zh: '最后更新' },
  footerMsg: { en: 'Released under the MIT License.', id: 'Dirilis di bawah Lisensi MIT.', ja: 'MIT ライセンスの下で公開されています。', ru: 'Распространяется по лицензии MIT.', zh: '基于 MIT 许可证发布。' },
  footerCopyright: {
    en: 'Copyright © 2024–present ANHub-Script · Based on WindUI by Footagesus',
    id: 'Hak Cipta © 2024–sekarang ANHub-Script · Berbasis WindUI oleh Footagesus',
    ja: 'Copyright © 2024–現在 ANHub-Script · Footagesus の WindUI をベース',
    ru: 'Авторское право © 2024–настоящее время ANHub-Script · На основе WindUI от Footagesus',
    zh: '版权所有 © 2024–至今 ANHub-Script · 基于 Footagesus 的 WindUI'
  }
}

const tr = (lang: Lang) => (key: keyof typeof UI): string => UI[key][lang] ?? UI[key].en

// ---------------------------------------------------------------------------
// Navbar
// ---------------------------------------------------------------------------
function nav(p: string, lang: Lang): DefaultTheme.NavItem[] {
  const t = tr(lang)
  return [
    { text: t('guide'), link: `${p}/guide/introduction`, activeMatch: `${p}/guide/` },
    { text: t('elements'), link: `${p}/elements/`, activeMatch: `${p}/elements/` },
    { text: t('features'), link: `${p}/features/notifications`, activeMatch: `${p}/features/` },
    { text: t('examples'), link: `${p}/examples/`, activeMatch: `${p}/examples/` },
    { text: t('reference'), link: `${p}/api/`, activeMatch: `${p}/api/` },
    {
      text: VERSION,
      items: [
        { text: t('releaseNotes'), link: `${GITHUB}/releases` },
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
function sidebar(p: string, lang: Lang): DefaultTheme.SidebarItem[] {
  const t = tr(lang)
  return [
    {
      text: t('gettingStarted'),
      collapsed: false,
      items: [
        { text: t('introduction'), link: `${p}/guide/introduction` },
        { text: t('installation'), link: `${p}/guide/installation` },
        { text: t('quickStart'), link: `${p}/guide/getting-started` },
        { text: t('windowConfig'), link: `${p}/guide/window-configuration` },
        { text: t('tabsSections'), link: `${p}/guide/tabs-and-sections` }
      ]
    },
    {
      text: t('elements'),
      collapsed: false,
      items: [
        { text: t('overview'), link: `${p}/elements/` },
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
      text: t('features'),
      collapsed: false,
      items: [
        { text: t('notifications'), link: `${p}/features/notifications` },
        { text: t('dialogsPopups'), link: `${p}/features/dialogs-and-popups` },
        { text: t('configFlags'), link: `${p}/features/config-and-flags` },
        { text: t('keySystem'), link: `${p}/features/key-system` },
        { text: t('githubKeys'), link: `${p}/features/github-key-system` },
        { text: t('themes'), link: `${p}/features/themes` },
        { text: t('localization'), link: `${p}/features/localization` },
        { text: t('scheduler'), link: `${p}/features/scheduler` },
        { text: t('openButton'), link: `${p}/features/open-button` }
      ]
    },
    {
      text: t('examples'),
      collapsed: false,
      items: [
        { text: t('overview'), link: `${p}/examples/` },
        { text: t('basicMenu'), link: `${p}/examples/basic-menu` },
        { text: t('configSystem'), link: `${p}/examples/config-system` },
        { text: t('categoryPages'), link: `${p}/examples/category-pages` }
      ]
    },
    {
      text: t('reference'),
      collapsed: false,
      items: [{ text: t('apiCheatsheet'), link: `${p}/api/` }]
    }
  ]
}

// ---------------------------------------------------------------------------
// Per-locale theme config
// ---------------------------------------------------------------------------
function localeTheme(p: string, lang: Lang): DefaultTheme.Config {
  const t = tr(lang)
  return {
    nav: nav(p, lang),
    sidebar: sidebar(p, lang),
    editLink: { pattern: `${DOCS_REPO}/edit/main/docs/:path`, text: t('editLink') },
    outline: { level: [2, 3], label: t('onThisPage') },
    docFooter: { prev: t('prev'), next: t('next') },
    lastUpdated: { text: t('lastUpdated') },
    footer: { message: t('footerMsg'), copyright: t('footerCopyright') }
  }
}

// Local-search UI strings per locale (English is built-in).
type SearchTr = { button: { buttonText: string; buttonAriaLabel: string }; modal: any }
function searchTr(buttonText: string, displayDetails: string, resetButtonTitle: string, noResultsText: string, selectText: string, navigateText: string, closeText: string): SearchTr {
  return {
    button: { buttonText, buttonAriaLabel: buttonText },
    modal: {
      displayDetails,
      resetButtonTitle,
      noResultsText,
      footer: { selectText, navigateText, closeText }
    }
  }
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
          id: searchTr('Cari', 'Tampilkan detail', 'Reset pencarian', 'Tidak ada hasil untuk', 'untuk memilih', 'untuk berpindah', 'untuk menutup'),
          ja: searchTr('検索', '詳細リストを表示', '検索をクリア', '結果が見つかりません', '選択', '切り替え', '閉じる'),
          ru: searchTr('Поиск', 'Показать подробности', 'Сбросить поиск', 'Нет результатов для', 'выбрать', 'перейти', 'закрыть'),
          zh: searchTr('搜索', '显示详细列表', '清除查询条件', '无法找到相关结果', '选择', '切换', '关闭')
        }
      }
    },
    socialLinks: [
      { icon: 'github', link: GITHUB },
      { icon: discordIcon, link: DISCORD }
    ]
  },

  locales: {
    root: { label: 'English', lang: 'en', themeConfig: localeTheme('', 'en') },
    id: { label: 'Bahasa Indonesia', lang: 'id', link: '/id/', themeConfig: localeTheme('/id', 'id') },
    ja: { label: '日本語', lang: 'ja', link: '/ja/', themeConfig: localeTheme('/ja', 'ja') },
    ru: { label: 'Русский', lang: 'ru', link: '/ru/', themeConfig: localeTheme('/ru', 'ru') },
    zh: { label: '简体中文', lang: 'zh-Hans', link: '/zh/', themeConfig: localeTheme('/zh', 'zh') }
  }
})
