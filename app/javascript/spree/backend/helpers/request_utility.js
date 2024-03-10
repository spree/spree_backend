import { RequestInterceptor } from "@rails/request.js"
import { FetchRequest } from "@rails/request.js"

//
// Inject Authorization & Content-Type into @rails/request.js requests.
RequestInterceptor.register(async (request) => {
  request.addHeader("Authorization", `Bearer ${OAUTH_TOKEN}`)
})

//
// Setup Turbo Progress bar on @rails/request.js requests.
export function showProgressBar() {
  Turbo.navigator.delegate.adapter.progressBar.setValue(0)
  Turbo.navigator.delegate.adapter.progressBar.show()
}

export function hideProgressBar() {
  Turbo.navigator.delegate.adapter.progressBar.setValue(1)
  Turbo.navigator.delegate.adapter.progressBar.hide()
}

export function withProgress(request) {
  new Promise(resolve => {
    showProgressBar()
    resolve(request.then(hideProgressBar))
  })
  return request
}

export function get (url, options) {
  const request = new FetchRequest("get", url, options)
  return withProgress(request.perform())
}

export function post (url, options) {
  const request = new FetchRequest("post", url, options)
  return withProgress(request.perform())
}

export function put (url, options) {
  const request = new FetchRequest("put", url, options)
  return withProgress(request.perform())
}

export function patch (url, options) {
  const request = new FetchRequest("patch", url, options)
  return withProgress(request.perform())
}

export function destroy (url, options) {
  const request = new FetchRequest("delete", url, options)
  return withProgress(request.perform())
}