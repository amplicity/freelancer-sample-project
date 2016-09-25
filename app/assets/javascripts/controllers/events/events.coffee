App.angular.controller(
  'EventsController'
  [
    '$scope'
    'Notification'
    'uiCalendarConfig'
    '$uibModal'
    '$http'
    ($scope, Notification, uiCalendarConfig, $uibModal, $http)->
      date = new Date
      d = date.getDate()
      m = date.getMonth()
      y = date.getFullYear()

      ### event source that contains custom events on the scope ###
      $scope.events = []
      $scope.eventSources = []

      eventModal = (model)->
        modalInstance = $uibModal.open(
          animation: 'true'
          templateUrl: 'modals/_addEventModal.html'
          controller: [
            '$uibModalInstance'
            ($uibModalInstance)->
              $ctrl = this;
              $ctrl.title = 'Add Event'

              $ctrl.dtPopup =
                from:
                  opened: false
                to:
                  opened: false

              $ctrl.dtPopupFromShow = (event, prop)->
                $ctrl.dtPopup.from.opened = true

              $ctrl.dtPopupToShow = (event, prop)->
                $ctrl.dtPopup.to.opened = true


              $ctrl.dtOptions =
                showWeeks: false

              if model
                $ctrl.isNew = false
                $ctrl.title = 'Edit Event'
                $ctrl.model = model
              else
                $ctrl.isNew = true
                $ctrl.model = {
                  title: null,
                  from: new Date(),
                  to: null,
                  description: null
                }

              $ctrl.save = ()->
                if $ctrl.isNew
                  $http.post('events', angular.toJson({model: $ctrl.model})).then((response)->
                    i = response.data
                    $scope.events.push({
                      id: i.id
                      title: i.title
                      start: i.from
                      end: i.to
                    })
                    $uibModalInstance.dismiss('cancel')
                  )
                else
                  $http.put('events/' + $ctrl.model.id, angular.toJson({model: $ctrl.model})).then((response)->
                    $scope.events.splice($scope.events.findIndex((e)-> e.id == $ctrl.model.id), 1)
                    i = response.data
                    $scope.events.push({
                      id: i.id
                      title: i.title
                      start: i.from
                      end: i.to
                    })
                    $uibModalInstance.dismiss('cancel')
                  )

              $ctrl.cancel = ()->
                $uibModalInstance.dismiss('cancel')

              $ctrl.remove = ()->
                $http.delete('events/' + $ctrl.model.id).then(()->
                  $scope.events.splice($scope.events.findIndex((e)-> e.id == $ctrl.model.id), 1)
                  $uibModalInstance.dismiss('cancel')
                )

              return $ctrl
          ]
          controllerAs: '$ctrl'
          size: 'md'
        )

      onEventClick = (event, element, view )->
        $http.get("events/#{event.id}").then((response)-> eventModal(response.data, event._id))

      $scope.uiConfig = {
        calendar:{
          customButtons:
            createEvent:
              text: 'Add Event'
              click: ()-> eventModal()
          editable: false
          header:
            left: 'title'
            center: ''
            right: 'createEvent today prev,next'
          eventClick: onEventClick
          viewRender: (view, el)->
            $http.get("events?year=#{view.intervalStart.get('year')}&month=#{view.intervalStart.get('month')}").then(
              (response)->
                $scope.events.splice(0,$scope.events.length)
                response.data.map((i)->
                  $scope.events.push({
                    id: i.id
                    title: i.title
                    start: i.from
                    end: i.to
                  })
                )
                $scope.eventSources = [$scope.events]
                console.log($scope.eventSources)
            )
#          eventDrop: $scope.alertOnDrop,
#          eventResize: $scope.alertOnResize,
#          eventRender: $scope.eventRender
        }
      }
      $scope.eventSources.push($scope.events)
  ]
)