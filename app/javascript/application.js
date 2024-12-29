// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

;(() => {
  // Make sure that all forms have actual up-to-date tokens (cached forms contain old ones)
  function refreshCSRFTokens () {
    const token = csrfToken()
    const param = csrfParam()

    if (token != null && param != null) {
    document.querySelectorAll(`form input[name="${param}"]`).forEach(input => {
        const inputEl = input
        inputEl.value = token
      })
    }
  }
  // Up-to-date Cross-Site Request Forgery token
  function csrfToken () {
    return getCookieValue(csrfParam()) ?? getMetaContent('csrf-token')
  }

  // URL param that must contain the CSRF token
  function csrfParam () {
    return getMetaContent('csrf-param')
  }

  function getCookieValue (cookieName) {
    if (cookieName != null) {
      const cookies = document.cookie.trim() !== '' ? document.cookie.split('; ') : []
      const cookie = cookies.find((cookie) => cookie.startsWith(cookieName))
      if (cookie != null) {
        const value = cookie.split('=').slice(1).join('=')
        return (value.trim() !== '' ? decodeURIComponent(value) : undefined)
      }
    }

    return undefined
  }

  function getMetaContent (str) {
    const elements = document.querySelectorAll(`meta[name="${str}"]`)
    const element = elements[elements.length - 1]
    return element?.content ?? undefined
  }

  function debounce(func, delay) {
    let timeoutId;

    return function(...args) {
      clearTimeout(timeoutId);

      timeoutId = setTimeout(() => {
        func.apply(this, args);
      }, delay);
    };
  }

  // Debounce so in case of very frequent updates.
  const debouncedRefresh = debounce(() => refreshCSRFTokens(), 20)

  // When elements are added, always update.
  const elementObserver = new MutationObserver((mutationRecords) => {
    debouncedRefresh()
  })

  elementObserver.observe(document.documentElement, {
    // Listen for any elements being added.
    childList: true,
    subtree: true,
  })
  refreshCSRFTokens()
})()
