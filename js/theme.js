// this one is jut to wait for the page to load
document.addEventListener("DOMContentLoaded", () => {
  const themeStylesheet = document.getElementById("theme");
  const themeToggle = document.getElementById("theme-toggle");
  const storedTheme = localStorage.getItem("theme");
  var prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;

  if (storedTheme) {
    if (themeStylesheet.href.includes("light")) {
      // if it's light -> go dark
      dark(themeStylesheet, themeToggle);
    } else {
      // if it's dark -> go light
      light(themeStylesheet, themeToggle);
    }
    localStorage.setItem("theme", themeStylesheet.href);
  }

  if (prefersDark) {
    dark(themeStylesheet, themeToggle);
  }

  themeToggle.addEventListener("click", () => {
    if (themeStylesheet.href.includes("light")) {
      // if it's light -> go dark
      dark(themeStylesheet, themeToggle);
    } else {
      // if it's dark -> go light
      light(themeStylesheet, themeToggle);
    }
    // save the preference to localStorage
  });
});
function dark(themeStylesheet, themeToggle) {
  themeStylesheet.href = "css/dark.css";
  themeToggle.innerHTML =
    '<i icon-name="sun" alt="light" title="Switch to light mode"></i>';
  lucide.createIcons();
  localStorage.setItem("theme", themeStylesheet.href);
}
function light(themeStylesheet, themeToggle) {
  themeStylesheet.href = "css/light.css";
  themeToggle.innerHTML =
    '<i icon-name="moon" alt="Dark" title="Switch to dark mode"></i>';
  lucide.createIcons();
  localStorage.setItem("theme", themeStylesheet.href);
}
