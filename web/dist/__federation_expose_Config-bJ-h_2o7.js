import { c as o, j as a, W as s, __tla as n } from "./App-Efb4meDL.js";
let l,
  t,
  i = Promise.all([
    (() => {
      try {
        return n;
      } catch {}
    })(),
  ]).then(async () => {
    let c, e, r;
    (c = o(
      [
        a.jsx("circle", { cx: "15", cy: "13", r: "1" }, "0"),
        a.jsx("circle", { cx: "9", cy: "13", r: "1" }, "1"),
        a.jsx("path", { d: "m8.33 7.5-.66 2h8.66l-.66-2z" }, "2"),
        a.jsx(
          "path",
          {
            d: "M20 2H4c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2m-1 15.69c0 .45-.35.81-.78.81h-.44c-.44 0-.78-.36-.78-.81V16.5H7v1.19c0 .45-.35.81-.78.81h-.44c-.43 0-.78-.36-.78-.81v-6.5c.82-2.47 1.34-4.03 1.56-4.69.05-.16.12-.29.19-.4.02-.02.03-.04.05-.06.38-.53.92-.54.92-.54h8.56s.54.01.92.53c.02.03.03.05.05.07.07.11.14.24.19.4.22.66.74 2.23 1.56 4.69z",
          },
          "3"
        ),
      ],
      "Garage"
    )),
      (e = () => a.jsx(c, { fontSize: "large" })),
      (r = () => a.jsx(c, { fontSize: "large" })),
      (t = "/npwd_mGarage"),
      (l = () => ({
        id: "npwd_mGarage",
        nameLocale: "Garage",
        color: "#fff",
        backgroundColor: "#333",
        path: t,
        icon: e,
        app: s,
        notificationIcon: r,
      }));
  });
export { i as __tla, l as default, t as path };
