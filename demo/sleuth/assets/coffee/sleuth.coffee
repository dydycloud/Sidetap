$(document).ready () ->

  st = sidetap()

  # content panels
  gallery    = $('#gallery')
  thumbnails = gallery.find('.thumbnails')
  detail     = $('#detail')
  about      = $('#about')

  # navigation structure
  $('header .menu').click st.toggle_nav

  $('header .info'    ).click () -> st.show_section(about,   {animation: 'upfrombottom'})
  $('#about  a.cancel').click () -> st.show_section(gallery, {animation: 'downfromtop'})
  $('#detail a.back'  ).click () -> st.show_section(gallery, {animation: 'infromleft'})


  $.getJSON 'assets/json/images.json', (images) ->

    # show the default section
    show_thumbnails(st.stp_nav.find('a.selected').text(), images)

    st.stp_nav.find('nav a').click () ->
      $(this).addClass('selected').siblings().removeClass('selected')
      st.toggle_nav()

      show_thumbnails($(this).text(), images)
      no


  show_thumbnails = (section, images) ->
    thumbnails.empty().addClass('loading')
    gallery.find('h1').text(section + ' Bears')

    thumbs = []

    total  = images[section].length
    loaded = 0

    # preload tumbnails
    thumbs.push $("<img src='#{img.url_s}' />").load(() ->
      loaded++
      render_thumbnails(images[section]) if loaded is total
    ) for img, i in images[section]


  render_thumbnails = (images) ->
    thumbnails.removeClass 'loading'

    thumbnails.append $("""
      <li#{if (i + 1) % 4 is 0 then ' class="right"' else ''}>
        <a href='#'><img src='#{img.url_s}' alt='#{i}' /></a>
      </li>"""
    ) for img, i in images

    $('#gallery .thumbnails a').click () ->
      show_image(images[$(this).find('img').prop('alt')])


  show_image = (img) =>
    detail.find('.stp-content-body img').replaceWith($("<img src='#{img.url_m}' />"))

    # show meta info for image
    detail.find('cite').html(img.title)
    detail.find('[rel="author"]')
          .prop('href', "http://flickr.com/photos/#{img.owner}/#{img.id}")
          .html(img.ownername)

    st.show_section(detail, {animation: 'infromright'})