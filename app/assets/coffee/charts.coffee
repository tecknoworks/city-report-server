initIssuesByCategoryChart = (data) ->
  $("#issuesByCategory").highcharts
    chart:
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false

    title:
      text: " "

    tooltip:
      pointFormat: "{series.name}: <b>{point.percentage:.1f}%</b>"

    plotOptions:
      pie:
        allowPointSelect: true
        cursor: "pointer"
        dataLabels:
          enabled: true
          format: "<b>{point.name}</b>: {point.percentage:.1f} %"
          style:
            color: (Highcharts.theme and Highcharts.theme.contrastTextColor) or "black"

    series: [
      type: "pie"
      name: "Issue share"
      data: data
    ]
  return

$ ->
  $.get "/report", (data) ->
    initIssuesByCategoryChart(data['body']['issues_by_category'])
    return

  return
