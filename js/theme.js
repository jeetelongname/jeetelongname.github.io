document.addEventListener("DOMContentLoaded", () => {
  const themeStylesheet = document.getElementById("theme");
  const themeToggle = document.getElementById("theme-toggle");
  const storedTheme = localStorage.getItem("theme");
  var prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
  var themeToToggle = light(themeStylesheet, themeToggle);

  if (storedTheme) {
    if (themeStylesheet.href.includes("light") || prefersDark) {
      // if it's light -> go dark
      themeToToggle = dark(themeStylesheet, themeToggle);
    } else {
      // if it's dark -> go light
      themeToToggle = light(themeStylesheet, themeToggle);
    }
    localStorage.setItem("theme", themeStylesheet.href);
  }

  themeToggle.addEventListener("click", () => {
    if (themeStylesheet.href.includes("light")) {
      // if it's light -> go dark
      themeToToggle = dark(themeStylesheet, themeToggle);
    } else {
      // if it's dark -> go light
      themeToToggle = light(themeStylesheet, themeToggle);
    }
  });
  themeToToggle; // now its only one function call
});

function toggleTheme(themeStylesheet, themeToggle, style, icon, message) {
  themeStylesheet.href = style;
  themeToggle.innerHTML = `<i icon-name="${icon}" alt="light" title="${message}"></i>`;
  lucide.createIcons();
  localStorage.setItem("theme", themeStylesheet.href);
}

function dark(themeStylesheet, themeToggle) {
  toggleTheme(
    themeStylesheet,
    themeToggle,
    "css/dark.css",
    "sun",
    "switch to light theme"
  );
}

function light(themeStylesheet, themeToggle) {
  toggleTheme(
    themeStylesheet,
    themeToggle,
    "css/light.css",
    "moon",
    "switch to dark theme"
  );
}
