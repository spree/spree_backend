import resolve from "@rollup/plugin-node-resolve"
import commonjs from "@rollup/plugin-commonjs"
import { terser } from "rollup-plugin-terser"

const terserOptions = {
  mangle: false,
  compress: false,
  format: {
    beautify: true,
    indent_level: 2
  }
}

export default [
  {
    input: "app/javascript/spree/dashboard/index.js",
    output: {
      file: "app/assets/javascripts/spree-dashboard.js",
      format: "umd",
      name: "SpreeDashboard"
    },
    plugins: [
      resolve(),
      commonjs(),
      terser(terserOptions)
    ]
  },

  {
    input: "app/javascript/spree/dashboard/index.js",
    output: {
      file: "app/assets/javascripts/spree-dashboard.esm.js",
      format: "es"
    },
    plugins: [
      resolve(),
      commonjs(),
      terser(terserOptions)
    ]
  }
]
