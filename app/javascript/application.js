// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// = require jquery
// = require popper
// = require turbolinks
// = require bootstrap
// = require_tree.

import React from "react"
import ReactDOM from "react-dom"

$(document).ready(function() {
    $('#openFormButton').click(function() {
      $('#formModal').modal('show');
    });
  });
  