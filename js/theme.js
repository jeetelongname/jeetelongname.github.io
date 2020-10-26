// this one is jut to wait for the page to load
document.addEventListener('DOMContentLoaded', () => {

    const themeStylesheet = document.getElementById('theme');
    const storedTheme = localStorage.getItem('theme');
    // const storedIcon  = localStorage.getItem('theme-toggle')
    if(storedTheme){
        themeStylesheet.href = storedTheme;
    }
    // if(storedIcon){
    //     themeToggle.innerHTML= storedIcon
    // }
    const themeToggle = document.getElementById('theme-toggle');
    themeToggle.addEventListener('click', () => {
        // if it's light -> go dark
        if(themeStylesheet.href.includes('light')){
            themeStylesheet.href = 'css/dark.css';
            themeToggle.innerHTML= '<i data-feather="sun" class="far fa-sun"></i>';
        } else {
            // if it's dark -> go light
            themeStylesheet.href = 'css/light.css';
            themeToggle.innerHTML = '<i data-feather="moon" class="far fa-moon"></i>';
        }
        // save the preference to localStorage
        localStorage.setItem('theme',themeStylesheet.href)  
        feather.replace()
        // localStorage.setItem('theme-toggle',themeToggle.innerHTML)
        
    })
})
