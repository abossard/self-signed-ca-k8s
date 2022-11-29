using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace web.Pages;

public class IndexModel : PageModel
{
    private readonly ILogger<IndexModel> _logger;
    
    public string? Message = "Hello World!";
    private readonly string _weatherForecastApi;

    public IndexModel(ILogger<IndexModel> logger, IConfiguration configuration)
    {
        _logger = logger;
        _weatherForecastApi = configuration.GetValue<string>("Services:Api:WeatherForecast");
    }

    public void OnGet()
    {
        // get json from api
        var client = new HttpClient();
        var response = client.GetAsync(_weatherForecastApi).Result;
        var json = response.Content.ReadAsStringAsync().Result;
        Message = json;
    }
}
