 //Station 3 Script

using Godot;
using System;

public partial class Station : Area2D
{
	private bool _playerNearby = false;

	public override void _Ready()
	{
		Connect("body_entered", new Callable(this, nameof(OnPlayerEnter)));
		Connect("body_exited", new Callable(this, nameof(OnPlayerExit)));
	}

	private void OnPlayerEnter(Node body)
	{
		if (body is Player)
		{
			_playerNearby = true;
			GD.Print("Press 'E' to use station.");
		}
	}

	private void OnPlayerExit(Node body)
	{
		if (body is Player)
		{
			_playerNearby = false;
		}
	}

	public override void _Process(double delta)
	{
		if (_playerNearby && Input.IsActionJustPressed("interact"))
		{
			GD.Print("Using Station!");
			// Add QTE logic here
		}
	}
}
