using BLL.DTOs;
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/users")]
public class UserController : ControllerBase
{
    private readonly UserService _service;

    public UserController(UserService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<IActionResult> GetUsers()
    {
        return Ok(await _service.GetUsers());
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register(UserRegisterDto dto)
    {
        await _service.RegisterUser(dto);
        return Ok("User registered successfully");
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var user = await _service.GetUserByIdAsync(id);

        if (user == null)
            return NotFound("User not found");

        return Ok(user);
    }

    [HttpPut]
    public async Task<IActionResult> Update(UserUpdateDto dto)
    {
        await _service.UpdateUser(dto);
        return Ok("User updated successfully");
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        await _service.DeleteUser(id);
        return Ok("User deleted successfully");
    }
}
