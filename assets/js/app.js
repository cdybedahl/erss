// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import 'bootstrap'
import $ from 'jquery'
import css from '../css/app.scss'


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
$(".tag").each((_i, e) => {
    let up = $(e).find(".up")
    let down = $(e).find(".down")
    let target = $(e).find(".rating")

    up.click((event) => {
        let url = up.attr("url")

        $.post({
            url: url,
            dataType: "json"
        }).done((data) => {
            target.text(data.rating)
        })

        event.stopPropagation()
    })

    down.click((event) => {
        let url = down.attr("url")

        $.post({
            url: url,
            dataType: "json"
        }).done((data) => {
            target.text(data.rating)
        })

        event.stopPropagation()
    })

})