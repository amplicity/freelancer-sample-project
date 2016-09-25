regexIso8601 = /^(\d{4}|\+\d{6})(?:-(\d{2})(?:-(\d{2})(?:T(\d{2}):(\d{2}):(\d{2})\.(\d{1,})(Z|([\-+])(\d{2}):(\d{2}))?)?)?)?$/;

convertDateStringsToDates = (input) ->
# Ignore things that aren't objects.
  if typeof input != 'object'
    return input
  for key of input
    if !input.hasOwnProperty(key)
      continue
    value = input[key]
    match = undefined
    # Check for string properties which look like dates.
    if typeof value == 'string' and (match = value.match(regexIso8601))
      milliseconds = Date.parse(match[0])
      if !isNaN(milliseconds)
        input[key] = new Date(milliseconds)
    else if typeof value == 'object'
# Recurse into object
      convertDateStringsToDates value
  return

App.angular = angular.module('tasks', ['ui.router', 'ui.calendar', 'ui.bootstrap', 'ui.bootstrap.datetimepicker', 'ui-notification', 'templates', 'Devise', 'angularFileUpload'])

App.angular.config (NotificationProvider) =>
  NotificationProvider.setOptions(delay: 2000)

App.angular.config(['$httpProvider',
    ($httpProvider, paginationTemplateProvider)->
      # set httpProvider to use convertDateStringsToDates
      $httpProvider.defaults.transformResponse.push((responseData)->
        convertDateStringsToDates(responseData)
        responseData
      )
  ])

