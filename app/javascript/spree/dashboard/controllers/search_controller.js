import { Controller } from "@hotwired/stimulus"
import autoComplete from "@tarekraafat/autocomplete.js"
import { get } from "../utilities/request_utility"

export default class extends Controller {
  connect() {
    const autoCompleteJS = new autoComplete(
      {
        placeHolder: "Search",
        data: {
          src: async (query) => {
            try {
              // Taxons
              const taxons = await get(`/api/v2/platform/taxons?filter[name_cont]=${query}`)
              const taxons_response = await taxons.json

              // Products
              const variants = await get(`/api/v2/platform/variants?filter[product_name_or_sku_cont]=${query}`)
              const variants_response = await variants.json

              // Users
              const users = await get(`/api/v2/platform/users?filter[email_cont]=${query}`)
              const users_response = await users.json

              // Orders
              const orders = await get(`/api/v2/platform/orders?filter[number_or_email_cont]=${query}`)
              const orders_response = await orders.json

              // Pages
              const pages = await get(`/api/v2/platform/cms_pages?filter[title_cont]=${query}`)
              const pages_response = await pages.json

              return formatResponse(taxons_response, variants_response, users_response, orders_response, pages_response)

            } catch (error) {
              return error
            }
          },

          // Data 'Object' key to be searched
          keys: ["taxon", "product", "user", "order", "page"]
        },
        threshold: 3,
        resultsList: {
          maxResults: 50,
        },
        resultItem: {
          element: (item, data) => {
            // Modify Results Item Style
            item.style = "display: flex; justify-content: space-between;"
            // Modify Results Item Content

            if (data.key === "product") {
              item.innerHTML = `
                <span style="text-overflow: ellipsis; white-space: nowrap; overflow: hidden;">
                  ${data.value.name}
                  <br>
                  <span class="global-search-result-sub">sku: </span> ${data.value.sku}
                </span>
                <span style="display: flex; align-items: center; font-size: 13px; font-weight: 100; text-transform: uppercase; color: rgba(0,0,0,.8);">
                  ${data.key}
                </span>`
            } else if (data.key === "order") {
              item.innerHTML = `
                <span style="text-overflow: ellipsis; white-space: nowrap; overflow: hidden;">
                  ${data.value.number}
                  <br>
                  <span class="global-search-result-sub">email: </span> ${data.value.email}
                  <br>
                  <span class="global-search-result-sub">state: </span> ${data.value.state}
                </span>
                <span style="display: flex; align-items: center; font-size: 13px; font-weight: 100; text-transform: uppercase; color: rgba(0,0,0,.8);">
                  ${data.key}
                </span>`
            } else if (data.key === "taxon") {
              item.innerHTML = `
                <span style="text-overflow: ellipsis; white-space: nowrap; overflow: hidden;">
                  ${data.value.pretty_name}
                  <br>
                  <span class="global-search-result-sub">permalink: </span> ${data.value.permalink}
                </span>
                <span style="display: flex; align-items: center; font-size: 13px; font-weight: 100; text-transform: uppercase; color: rgba(0,0,0,.8);">
                  ${data.key}
                </span>`
            } else {
              item.innerHTML = `
                <span style="text-overflow: ellipsis; white-space: nowrap; overflow: hidden;">
                  ${data.match}
                </span>
                <span style="display: flex; align-items: center; font-size: 13px; font-weight: 100; text-transform: uppercase; color: rgba(0,0,0,.8);">
                  ${data.key}
                </span>`
            }
          },

          highlight: false
        }
      })

    function formatResponse(taxons, variants, users, orders, pages) {
      let response_array = []

      taxons.data.forEach(function (taxon) {
        response_array.push({
          "taxon": taxon.attributes.name,
          "uri": `/admin/taxonomies/${taxon.relationships.taxonomy.data.id}/taxons/${taxon.id}/edit`,
          "pretty_name": taxon.attributes.pretty_name,
          "permalink": taxon.attributes.permalink,

          // Placeholders
          "product": "", "user": "", "order": "", "page": ""
        })
      })

      variants.data.forEach(function (variant) {
        response_array.push({
          "product": variant.attributes.name + " " + variant.attributes.sku,
          "uri": `/admin/products/${variant.relationships.product.data.id}/edit`,
          "sku": variant.attributes.sku,
          "name": variant.attributes.name,

          // Placeholders
          "user": "", "order": "", "taxon": "", "page": ""
        })
      })

      users.data.forEach(function (user) {
        response_array.push({
          "user": user.attributes.email,
          "uri": `/admin/users/${user.id}/edit`,

          // Placeholders
          "product": "", "order": "", "taxon": "", "page": ""
        })
      })

      orders.data.forEach(function (order) {
        console.log(order)
        response_array.push({
          "order": order.attributes.number + " " + order.attributes.email,
          "uri": `/admin/orders/${order.attributes.number}/edit`,
          "email": order.attributes.email,
          "number": order.attributes.number,
          "state": order.attributes.state,

          // Placeholders
          "product": "", "user": "", "taxon": "", "page": ""
        })
      })

      pages.data.forEach(function (page) {
        response_array.push({
          "page": page.attributes.title,
          "uri": `/admin/cms_pages/${page.id}/edit`,

          // Placeholders
          "order": "", "product": "", "user": "", "taxon": ""
        })
      })

      return response_array
    }

    // Redirect to URI on selection
    autoCompleteJS.input.addEventListener("selection", function (event) {
      const uri = event.detail.selection.value["uri"]

      Turbo.visit(uri)
    })
  }
}
