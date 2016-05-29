grabGemRepo = () ->
  jem_id = parseInt( $('#jem_id').text() )

  $.ajax({
    url: '/get_gem_repo'
    dataType: "json"
    data: jem_id: jem_id
    success: (data) ->
      console.log('success grabGemRepo')
      console.log(data)
      jem_name = $('#jem_name').text()
      github_link = $('<a></a>').attr('href', data['gem_repo_link'])
                                .attr('target', '_blank')
                                .addClass('github-repo-value')

      $('#github-repo-value').text('').prepend(github_link)
      $('.github-repo-value').text('github/' + jem_name)

      rubygem_link = $('<a></a>').attr('href', data['rubygem_link'])
                                 .attr('target', '_blank')
                                 .addClass('rubygem-value')
                                 
      $('#rubygem-value').text('').prepend(rubygem_link)
      $('.rubygem-value').text('Rubygem Link')
    error: (data) ->
      console.log 'error with grabGemRepo'
      console.log(data)
  })

queryForPercentage = () ->
  job_id = $('#job_id').text()
  console.log 'sending ' + job_id + 'to /percentage_done'
  $.ajax({
    url: "/percentage_done"
    data:
      job_id: job_id
    success: (data) ->
      percentage = 'width: ' + data['percentage_done'] + '%;'
      $('#job-progress').attr('style', percentage).text(data['percentage_done'] + '%')
      $('#job_messages h2').text(data['job_message'])
      console.log(data['percentage_done'])

      if !$('.make-gem-button').hasClass('disabled')
        #disable buttons when creating gem
        $('.make-gem-button').addClass('disabled')
        $('.make-gem-button').prop('disabled', true);

      if $('#job-progress').text() != '100%'
        setTimeout(queryForPercentage, 1500)
      else
        $('.make-gem-button').removeClass('disabled')
        $('.make-gem-button').prop('disabled', false);
        grabGemRepo()
        swapGenerateForUpdateButton()
  })

swapGenerateForUpdateButton = () ->
  $('.submit-container #generate-gem-form').remove()
  $('.update-modal-button').remove()
  $('#update-modal-button').remove()
  $('.submit-container').prepend('<input type="submit" class="btn btn-primary btn-sm pull-right update-modal-button" data-toggle="modal" data-target="#versionModal" value="Update Gem">')
  
updateVersion = () ->
  # function to update both the version and commit message
  # with information in the #versionModal modal
  console.log 'Update version button clicked'
  new_version_number = $('#new_version_number').val()
  jem_id = $('#jem_id').text()
  new_commit_message = $('#new_commit_message').val()
  $.ajax({
    url: '/update_version'
    type: "POST"
    data:
      new_jem_version: new_version_number
      new_commit_message: new_commit_message
      id: jem_id
    success: (data) ->
      console.log('Version updated to' + data)
    error: (data) ->
      alert('failed to update!')
  })

disableGemButtons = () ->
  if $('#file-list tbody tr').size() == 0
    console.log('buttons disabled')
    $('.make-gem-button').prop('disabled', true)

enableGemButtons = () ->
  console.log('buttons enabled')
  $('.make-gem-button').prop('disabled', false)

jQuery(document).ready () ->

  $('#new-script').fileupload
    dataType: "script"
    add: (e, data) ->
      types = /(\.|\/)(js|coffee|css|scss|jpe?g|png|gif)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        $('#new-script').append(data.context)
        enableGemButtons()
        $('.no-gems-panel').fadeOut()
        data.submit()
      else
        alert("#{file.name} is not a javascript, CSS, or image file")

  disableGemButtons()

  $('#job-id-container').bind('DOMSubtreeModified', queryForPercentage )

  $(document).on "click", ".fileinput-button", ->
    $('#file-input').click()
    console.log 'file input clicked'

  $('#update-gem-button').click( () ->
    percentage = 'width: 0%;'
    $('#job-progress').attr('style', percentage).text('0%')
    updateVersion()
    $('#versionModal').modal('hide')
  )



  