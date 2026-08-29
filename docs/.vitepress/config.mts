import { defineConfig, type DefaultTheme } from 'vitepress'
import { readFileSync } from 'node:fs'
import { fileURLToPath } from 'node:url'

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
const GITHUB = 'https://github.com/ANHub-Script/ANUI'
const DISCORD = 'https://discord.gg/qN47S3mKZA'
const YOUTUBE = 'https://www.youtube.com/@ANHubRoblox'

type Lang = 'en' | 'id' | 'ja' | 'ru' | 'th' | 'zh' | 'ko'
type Entry = Record<Lang, string>

const UI: Record<string, Entry> = {
  guide: { en:'Guide', id:'Panduan', ja:'ガイド', ru:'Руководство', th:'คู่มือ', zh:'指南', ko:'가이드' },
  elements: { en:'Elements', id:'Elemen', ja:'エレメント', ru:'Элементы', th:'อิลิเมนต์', zh:'组件', ko:'요소' },
  features: { en:'Features', id:'Fitur', ja:'機能', ru:'Возможности', th:'ฟีเจอร์', zh:'功能', ko:'기능' },
  examples: { en:'Examples', id:'Contoh', ja:'サンプル', ru:'Примеры', th:'ตัวอย่าง', zh:'示例', ko:'예제' },
  reference: { en:'Reference', id:'Referensi', ja:'リファレンス', ru:'Справочник', th:'เอกสารอ้างอิง', zh:'参考', ko:'레퍼런스' },
  releaseNotes: { en:'Release Notes', id:'Catatan Rilis', ja:'リリースノート', ru:'Список изменений', th:'บันทึกการอัปเดต', zh:'更新日志', ko:'릴리스 노트' },
  gettingStarted: { en:'Getting Started', id:'Memulai', ja:'入門', ru:'Начало работы', th:'เริ่มต้น', zh:'快速开始', ko:'시작하기' },
  introduction: { en:'Introduction', id:'Pengenalan', ja:'はじめに', ru:'Введение', th:'บทนำ', zh:'简介', ko:'소개' },
  installation: { en:'Installation', id:'Instalasi', ja:'インストール', ru:'Установка', th:'การติดตั้ง', zh:'安装', ko:'설치' },
  quickStart: { en:'Quick Start', id:'Mulai Cepat', ja:'クイックスタート', ru:'Быстрый старт', th:'เริ่มใช้งานด่วน', zh:'快速上手', ko:'빠른 시작' },
  windowConfig: { en:'Window Configuration', id:'Konfigurasi Window', ja:'ウィンドウ設定', ru:'Настройка окна', th:'การตั้งค่าหน้าต่าง', zh:'窗口配置', ko:'윈도우 설정' },
  tabsSections: { en:'Tabs & Sections', id:'Tab & Section', ja:'タブとセクション', ru:'Вкладки и разделы', th:'แท็บและเซกชัน', zh:'标签页与分区', ko:'탭 및 섹션' },
  overview: { en:'Overview', id:'Ikhtisar', ja:'概要', ru:'Обзор', th:'ภาพรวม', zh:'概览', ko:'개요' },
  notifications: { en:'Notifications', id:'Notifikasi', ja:'通知', ru:'Уведомления', th:'การแจ้งเตือน', zh:'通知', ko:'알림' },
  dialogsPopups: { en:'Dialogs & Popups', id:'Dialog & Popup', ja:'ダイアログとポップアップ', ru:'Диалоги и всплывающие окна', th:'ไดอะล็อกและป๊อปอัป', zh:'对话框与弹窗', ko:'대화 상자 및 팝업' },
  configFlags: { en:'Config & Flags', id:'Konfigurasi & Flag', ja:'設定と Flag', ru:'Конфигурация и флаги', th:'การตั้งค่าและ Flag', zh:'配置与 Flag', ko:'설정 및 플래그' },
  keySystem: { en:'Key System', id:'Sistem Key', ja:'キーシステム', ru:'Система ключей', th:'ระบบ Key', zh:'密钥系统', ko:'키 시스템' },
  githubKeys: { en:'GitHub Key System', id:'Sistem Key GitHub', ja:'GitHub キーシステム', ru:'Ключи через GitHub', th:'ระบบ Key GitHub', zh:'GitHub 密钥系统', ko:'GitHub 키 시스템' },
  themes: { en:'Themes & Appearance', id:'Tema & Tampilan', ja:'テーマと外観', ru:'Темы и оформление', th:'ธีมและรูปลักษณ์', zh:'主题与外观', ko:'테마 및 외관' },
  localization: { en:'Localization', id:'Lokalisasi', ja:'ローカライズ', ru:'Локализация', th:'การแปลภาษา', zh:'本地化', ko:'다국어 지원' },
  scheduler: { en:'Scheduler & Loops', id:'Scheduler & Loop', ja:'スケジューラーとループ', ru:'Планировщик и циклы', th:'ตัวกำหนดเวลาและลูป', zh:'调度器与循环', ko:'스케줄러 및 루프' },
  openButton: { en:'Open Button', id:'Tombol Buka', ja:'オープンボタン', ru:'Кнопка открытия', th:'ปุ่มเปิด', zh:'打开按钮', ko:'열기 버튼' },
  basicMenu: { en:'Basic Menu', id:'Menu Dasar', ja:'基本メニュー', ru:'Базовое меню', th:'เมนูพื้นฐาน', zh:'基础菜单', ko:'기본 메뉴' },
  configSystem: { en:'Config System', id:'Sistem Konfigurasi', ja:'設定システム', ru:'Система конфигурации', th:'ระบบการตั้งค่า', zh:'配置系统', ko:'설정 시스템' },
  categoryPages: { en:'Category Pages', id:'Halaman Kategori', ja:'カテゴリーページ', ru:'Страницы категорий', th:'หน้าหมวดหมู่', zh:'分类页面', ko:'카테고리 페이지' },
  apiCheatsheet: { en:'API Cheatsheet', id:'Ringkasan API', ja:'API チートシート', ru:'Шпаргалка по API', th:'สรุป API', zh:'API 速查表', ko:'API 치트시트' },
  editLink: { en:'Edit this page on GitHub', id:'Edit halaman ini di GitHub', ja:'このページを GitHub で編集', ru:'Редактировать эту страницу на GitHub', th:'แก้ไขหน้านี้บน GitHub', zh:'在 GitHub 上编辑此页', ko:'GitHub에서 이 페이지 편집' },
  onThisPage: { en:'On this page', id:'Di halaman ini', ja:'このページの内容', ru:'На этой странице', th:'ในหน้านี้', zh:'本页目录', ko:'이 페이지에서' },
  prev: { en:'Previous', id:'Sebelumnya', ja:'前へ', ru:'Назад', th:'ก่อนหน้า', zh:'上一页', ko:'이전' },
  next: { en:'Next', id:'Berikutnya', ja:'次へ', ru:'Вперёд', th:'ถัดไป', zh:'下一页', ko:'다음' },
  lastUpdated: { en:'Last updated', id:'Terakhir diperbarui', ja:'最終更新', ru:'Последнее обновление', th:'อัปเดตล่าสุด', zh:'最后更新', ko:'마지막 업데이트' },
  footerMsg: { en:'Released under the MIT License.', id:'Dirilis di bawah Lisensi MIT.', ja:'MIT ライセンスの下で公開されています。', ru:'Распространяется по лицензии MIT.', th:'เผยแพร่ภายใต้สัญญาอนุญาต MIT', zh:'基于 MIT 许可证发布。', ko:'MIT 라이선스에 따라 배포됩니다.' },
  footerCopyright: { en:'Copyright © 2024–present ANHub-Script · Based on WindUI by Footagesus', id:'Hak Cipta © 2024–sekarang ANHub-Script · Berbasis WindUI oleh Footagesus', ja:'Copyright © 2024–現在 ANHub-Script · Footagesus の WindUI をベース', ru:'Авторское право © 2024–настоящее время ANHub-Script · На основе WindUI от Footagesus', th:'ลิขสิทธิ์ © 2024–ปัจจุบัน ANHub-Script · พัฒนาต่อยอดจาก WindUI โดย Footagesus', zh:'版权所有 © 2024–至今 ANHub-Script · 基于 Footagesus 的 WindUI', ko:'Copyright © 2024–현재 ANHub-Script · Footagesus의 WindUI 기반' }
}

const tr = (lang: Lang) => (key: keyof typeof UI): string => UI[key][lang] ?? UI[key].en

function nav(p: string, lang: Lang): DefaultTheme.NavItem[] {
  const t = tr(lang)
  return [
    { text:t('guide'), link:`${p}/guide/introduction`, activeMatch:`${p}/guide/` },
    { text:t('elements'), link:`${p}/elements/`, activeMatch:`${p}/elements/` },
    { text:t('features'), link:`${p}/features/notifications`, activeMatch:`${p}/features/` },
    { text:t('examples'), link:`${p}/examples/`, activeMatch:`${p}/examples/` },
    { text:t('reference'), link:`${p}/api/`, activeMatch:`${p}/api/` },
    { text:VERSION, items:[
      { text:t('releaseNotes'), link:`${GITHUB}/releases` },
      { text:'GitHub', link:GITHUB }, { text:'Discord', link:DISCORD }, { text:'YouTube', link:YOUTUBE }
    ] }
  ]
}

function sidebar(p: string, lang: Lang): DefaultTheme.Sidebar {
  const t = tr(lang)
  return [
    { text:t('gettingStarted'), items:[
      { text:t('introduction'), link:`${p}/guide/introduction` },
      { text:t('installation'), link:`${p}/guide/installation` },
      { text:t('quickStart'), link:`${p}/guide/getting-started` },
      { text:t('windowConfig'), link:`${p}/guide/window-configuration` },
      { text:t('tabsSections'), link:`${p}/guide/tabs-and-sections` }
    ] },
    { text:t('elements'), items:[
      'button','toggle','slider','dropdown','input','keybind','colorpicker','paragraph','code','divider','space','image','group','category'
    ].map(x=>({ text:x[0].toUpperCase()+x.slice(1), link:`${p}/elements/${x}` })) },
    { text:t('features'), items:[
      { text:t('overview'), link:`${p}/features/` }, { text:t('notifications'), link:`${p}/features/notifications` },
      { text:t('dialogsPopups'), link:`${p}/features/dialogs-popups` }, { text:t('configFlags'), link:`${p}/features/config-and-flags` },
      { text:t('keySystem'), link:`${p}/features/key-system` }, { text:t('githubKeys'), link:`${p}/features/github-key-system` },
      { text:t('themes'), link:`${p}/features/themes` }, { text:t('localization'), link:`${p}/features/localization` },
      { text:t('scheduler'), link:`${p}/features/scheduler` }, { text:t('openButton'), link:`${p}/features/open-button` }
    ] },
    { text:t('examples'), items:[
      { text:t('basicMenu'), link:`${p}/examples/basic-menu` }, { text:t('configSystem'), link:`${p}/examples/config-system` }, { text:t('categoryPages'), link:`${p}/examples/category-pages` }
    ] },
    { text:t('reference'), items:[{ text:t('apiCheatsheet'), link:`${p}/api/` }] }
  ]
}

const languages = {
  en:{label:'English',link:'/'}, id:{label:'Bahasa Indonesia',link:'/id/'}, ja:{label:'日本語',link:'/ja/'}, ru:{label:'Русский',link:'/ru/'}, th:{label:'ไทย',link:'/th/'}, zh:{label:'简体中文',link:'/zh/'}, ko:{label:'한국어',link:'/ko/'}
}

const locales = Object.fromEntries(Object.entries(languages).map(([code, meta])=>{
  const lang = code as Lang
  const p = meta.link === '/' ? '' : meta.link.slice(0,-1)
  const t = tr(lang)
  return [code,{label:meta.label,lang:code,themeConfig:{nav:nav(p,lang),sidebar:sidebar(p,lang),outline:{label:t('onThisPage')},editLink:{pattern:`${GITHUB}/edit/main/docs${p}/:path`},lastUpdated:{text:t('lastUpdated')},docFooter:{prev:t('prev'),next:t('next')},footer:{message:t('footerMsg'),copyright:t('footerCopyright')}}}]
}))

export default defineConfig({
  title:'ANUI', description:'A modern, feature-rich UI library for Roblox script executors.',
  base:'/', cleanUrls:true, lastUpdated:true,
  themeConfig:{
    search:{provider:'local'}, socialLinks:[{icon:'github',link:GITHUB}],
    langMenuLabel:'Languages', sidebarMenuLabel:'Menu', returnToTopLabel:'Back to top',
    locales
  }
})
