SYSTEM PROMPT
Go Todo List — Frontend Context
Astro  •  REST API  •  Go Lang Backend
1. Identitas Proyek
Dokumen ini adalah system prompt / AI context untuk pengembangan frontend aplikasi Go Todo List. Gunakan konteks ini setiap kali meminta bantuan AI agar respons yang diberikan selalu selaras dengan arsitektur, konvensi, dan fitur aplikasi ini.

Nama Proyek
Go Todo List
Backend
Go Lang (Golang) — REST API
Frontend
Astro (Static Site Framework)
Styling
Tailwind CSS
State Mgmt
React Islands (client:load / client:visible)
HTTP Client
fetch() native / axios (opsional)
Port Dev
Backend :8080  |  Frontend :4321
Format Data
JSON (application/json)


2. Arsitektur Sistem
2.1 Gambaran Umum
Aplikasi terdiri dari dua layer yang terpisah secara penuh:
Backend Go Lang mengekspos REST API murni. Tidak ada rendering HTML dari sisi server Go.
Frontend Astro mengonsumsi API tersebut melalui fetch() di komponen React islands.
Komunikasi seluruhnya via JSON over HTTP. Tidak ada WebSocket atau gRPC di sisi frontend.

2.2 Diagram Alur Data
Alur Request
User Input  →  React Component  →  fetch() ke Go API
Go API  →  JSON Response  →  React State  →  UI Update


3. Fitur Aplikasi
3.1 CRUD Task
Tambah Task
POST /api/tasks  —  body: { title, category_id }
Lihat Tasks
GET /api/tasks  —  mengembalikan array semua task
Edit Task
PUT /api/tasks/:id  —  body: { title, completed }
Hapus Task
DELETE /api/tasks/:id
Toggle Done
PATCH /api/tasks/:id/toggle  —  flip status completed


3.2 Kategori / Group Task
Buat Grup
POST /api/categories  —  body: { name }
List Kategori
GET /api/categories  —  array kategori + jumlah task
Hapus Kategori
DELETE /api/categories/:id  —  cascade hapus task di dalamnya
Filter by Cat
GET /api/tasks?category_id=X


3.3 REST API — Format Response Standar
Semua endpoint Go mengembalikan envelope JSON berikut:

Response sukses
{ "status": "success", "data": { ... }, "message": "" }


Response error
{ "status": "error",   "data": null,  "message": "pesan error" }


3.4 Simple Game Logic
Aplikasi memiliki elemen gamifikasi ringan yang tertanam di frontend:
Streak Harian: setiap hari user menyelesaikan minimal 1 task, streak bertambah.
XP System: setiap task selesai memberikan +10 XP. Task berprioritas +20 XP.
Level: Level = floor(XP / 100). Ditampilkan sebagai badge di profil.
Achievement: unlock badge khusus saat streak 7 hari, 50 task selesai, dsb.
State game disimpan di localStorage, bukan di backend Go.

4. Konvensi Frontend (Astro)
4.1 Struktur Direktori
Layout proyek Astro
src/
  components/    # React .jsx — semua UI interaktif
  layouts/        # Layout.astro — wrapper halaman
  pages/          # *.astro — routing file-based
  data/           # *.json — data statis lokal
  lib/api.js      # Helper fetch wrapper ke Go API
  lib/game.js     # Logic streak, XP, level, achievement


4.2 Aturan Komponen
File .astro digunakan hanya untuk halaman/layout statis.
Semua komponen interaktif (form, list, game UI) ditulis sebagai React .jsx.
Komponen React dipanggil dari .astro dengan directive: client:load atau client:visible.
DILARANG menggunakan <form> HTML biasa — selalu pakai event handler React (onClick, onSubmit via e.preventDefault()).
State lokal cukup dengan useState. Tidak ada Redux/Zustand/Context kecuali sangat perlu.

4.3 Pola Fetch ke Go API
Contoh helper — src/lib/api.js
const BASE = import.meta.env.PUBLIC_API_URL ?? "http://localhost:8080";

export async function apiFetch(path, opts = {}) {
  const res  = await fetch(BASE + path, {
    headers: { "Content-Type": "application/json" },
    ...opts,
  });
  const json = await res.json();
  if (json.status === "error") throw new Error(json.message);
  return json.data;
}


5. Aturan AI — Cara Membantu Proyek Ini
5.1 Yang HARUS Dilakukan
Selalu tulis komponen UI sebagai React .jsx dengan Tailwind CSS.
Gunakan apiFetch() dari src/lib/api.js — jangan tulis fetch() langsung di komponen.
Tangani loading state (isLoading) dan error state di setiap operasi async.
Ikuti format response Go: cek field status sebelum mengakses data.
Game logic (XP, streak, level) dikelola di src/lib/game.js dan state React — tidak masuk ke API call.
Gunakan Tailwind utility classes. Tidak ada CSS module atau styled-components.
Setiap komponen baru harus bisa menerima props yang relevan dan memiliki nilai default.

5.2 Yang DILARANG
Jangan tulis JSX langsung di file .astro (kecuali Astro component expression {}).
Jangan gunakan localStorage untuk data task/kategori — itu urusan Go backend.
Jangan tambahkan library baru tanpa konfirmasi (misal: React Query, SWR, Zustand).
Jangan hardcode URL API — selalu gunakan BASE dari env atau konstanta terpusat.
Jangan buat endpoint baru di Go tanpa menyertakan kontrak JSON-nya di sini dulu.

5.3 Contoh Prompt yang Efektif
Gunakan prompt seperti ini saat meminta bantuan AI:
"Buatkan komponen TaskList.jsx yang fetch GET /api/tasks dan tampilkan per kategori. Gunakan apiFetch(), tangani loading & error, styling Tailwind."
"Tambahkan logika XP di game.js — task selesai +10 XP, task dengan flag priority +20 XP. Simpan di localStorage dengan key go_todo_game."
"Perbaiki komponen AddTaskForm.jsx agar setelah submit berhasil, form dikosongkan dan list task di-refresh tanpa reload halaman."


6. Variabel Environment
PUBLIC_API_URL
URL base Go API. Default: http://localhost:8080
PUBLIC_APP_NAME
Nama aplikasi untuk ditampilkan di UI. Default: Go Todo
PUBLIC_GAME_KEY
Key localStorage untuk data game. Default: go_todo_game


Semua variabel harus diawali PUBLIC_ agar bisa diakses di sisi client Astro (import.meta.env.PUBLIC_*).

7. Referensi Endpoint Go API
Method
Endpoint
Body / Query
Keterangan
GET
/api/tasks
?category_id (opt)
List semua task
POST
/api/tasks
{ title, category_id }
Buat task baru
PUT
/api/tasks/:id
{ title, completed }
Update task
PATCH
/api/tasks/:id/toggle
-
Toggle selesai
DELETE
/api/tasks/:id
-
Hapus task
GET
/api/categories
-
List kategori
POST
/api/categories
{ name }
Buat kategori
DELETE
/api/categories/:id
-
Hapus kategori + tasks

