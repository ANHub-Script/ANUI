import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"ตัวอย่าง","description":"","frontmatter":{},"headers":[],"relativePath":"th/examples/index.md","filePath":"th/examples/index.md","lastUpdated":1787778240000}');
const _sfc_main = { name: "th/examples/index.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="ตัวอย่าง" tabindex="-1">ตัวอย่าง <a class="header-anchor" href="#ตัวอย่าง" aria-label="Permalink to &quot;ตัวอย่าง&quot;">​</a></h1><p>สูตรพร้อมวางที่รวมองค์ประกอบ ANUI เป็นเมนูจริง แต่ละอันเป็นสคริปต์อิสระที่คุณสามารถวางใน executor และรันได้ทันที</p><h2 id="สูตร" tabindex="-1">สูตร <a class="header-anchor" href="#สูตร" aria-label="Permalink to &quot;สูตร&quot;">​</a></h2><ul><li><strong><a href="/ANUI/th/examples/basic-menu">เมนูพื้นฐาน</a></strong> — เมนูเริ่มต้น: หนึ่ง window, หลาย tab, และผสมผสานองค์ประกอบทั่วไป (Toggle, Slider, Dropdown, Button, Keybind, Paragraph) พร้อมการแจ้งเตือน</li><li><strong><a href="/ANUI/th/examples/config-system">ระบบการกำหนดค่า</a></strong> — บันทึกและโหลดการตั้งค่าผู้ใช้ด้วยองค์ประกอบที่มี flag, ตัวเลือก config ที่โหลดจากดิสก์, และ toggle auto-load</li><li><strong><a href="/ANUI/th/examples/category-pages">หน้าหมวดหมู่</a></strong> — สร้าง &quot;หน้า&quot; show/hide ในหนึ่ง tab ด้วยองค์ประกอบ <a href="/ANUI/th/elements/category">Category</a></li></ul><div class="tip custom-block"><p class="custom-block-title">สคริปต์ demo ฉบับสมบูรณ์</p><p>สูตรเหล่านี้ถูกตัดให้กระชับ สำหรับ demo อย่างเป็นทางการที่สมบูรณ์ — พร้อมทุกองค์ประกอบและฟีเจอร์ — มีใน repository เป็น <code>main_example.lua</code> ที่ <a href="https://github.com/ANHub-Script/ANUI" target="_blank" rel="noreferrer">GitHub</a></p></div></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("th/examples/index.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const index = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  index as default
};
