import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Contoh","description":"","frontmatter":{},"headers":[],"relativePath":"id/examples/index.md","filePath":"id/examples/index.md","lastUpdated":1787644471000}');
const _sfc_main = { name: "id/examples/index.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="contoh" tabindex="-1">Contoh <a class="header-anchor" href="#contoh" aria-label="Permalink to &quot;Contoh&quot;">​</a></h1><p>Resep siap-tempel yang menggabungkan elemen ANUI menjadi menu nyata. Masing-masing adalah script mandiri yang bisa langsung Anda tempel ke executor dan jalankan.</p><h2 id="resep" tabindex="-1">Resep <a class="header-anchor" href="#resep" aria-label="Permalink to &quot;Resep&quot;">​</a></h2><ul><li><strong><a href="/ANUI/id/examples/basic-menu">Menu Dasar</a></strong> — Menu awal: sebuah window, beberapa tab, dan campuran elemen umum (Toggle, Slider, Dropdown, Button, Keybind, Paragraph) plus sebuah notifikasi.</li><li><strong><a href="/ANUI/id/examples/config-system">Sistem Konfigurasi</a></strong> — Simpan dan muat pengaturan pengguna dengan elemen ber-flag, pemilih config yang diisi dari disk, dan toggle auto-load.</li><li><strong><a href="/ANUI/id/examples/category-pages">Halaman Kategori</a></strong> — Bangun &quot;halaman&quot; show/hide di dalam satu tab dengan elemen <a href="/ANUI/id/elements/category">Category</a>.</li></ul><div class="tip custom-block"><p class="custom-block-title">Skrip demo lengkap</p><p>Resep ini dipangkas agar ringkas. Demo resmi yang lengkap — dengan setiap elemen dan fitur terpasang — ada di repositori sebagai <code>main_example.lua</code> di <a href="https://github.com/ANHub-Script/ANUI" target="_blank" rel="noreferrer">GitHub</a>.</p></div></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("id/examples/index.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const index = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  index as default
};
