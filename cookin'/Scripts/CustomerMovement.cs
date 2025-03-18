//Customer Movement

using Godot;
using System;

public partial class Customer : CharacterBody2D
{
	[Export] public float Speed = 50.0f;
	private Vector2 _targetPosition;

	public override void _Ready()
	{
		_targetPosition = GetParent().GetNode<Marker2D>("Marker2D").Position;
	}

	public override void _Process(double delta)
	{
		Vector2 direction = (_targetPosition - Position).Normalized();
		Position += direction * (float)(Speed * delta);

		if (Position.DistanceTo(_targetPosition) < 5)
		{
			Speed = 0; // Stop when reaching the target
		}
	}
}
