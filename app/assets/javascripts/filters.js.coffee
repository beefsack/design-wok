'use strict'

angular.module('designWok.filters', []).
  filter 't', ->
    return (input) ->
      pieces = input.split '.'
      ptr = lang[this.application.locale]
      ptr = ptr[piece] for piece in pieces when ptr?
      return ptr
      console.log input
      return 'fart'
