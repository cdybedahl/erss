// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

document.querySelectorAll(".ratebutton").forEach((node) => {
    node.addEventListener("click", (event) => {
        let xhr = new XMLHttpRequest()
        xhr.onreadystatechange = () => {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                if (xhr.status == 200) {
                    let new_tag = JSON.parse(xhr.responseText)
                    let target = node.parentElement.parentElement.querySelector(".tag_rating")
                    target.textContent = new_tag.rating
                } else {
                    console.log("Done with error: " + xhr.status)
                }
            }
        }
        xhr.open("POST", "/api" + node.getAttribute("data-to"))
        xhr.setRequestHeader("x-csrf-token", node.getAttribute("data-csrf"))
        xhr.send()

        event.stopPropagation()
    })
})