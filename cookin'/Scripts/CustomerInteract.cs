using Godot;
using System;

public partial class Player : CharacterBody2D
{
	public override void _Ready()
	{
		GetNode<Area2D>("InteractArea").Connect("body_entered", new Callable(this, nameof(OnCustomerEntered)));
	}

	private void OnCustomerEntered(Node body)
	{
		if (body is Customer customer)
		{
			GD.Print("Customer arrived at the counter!");
		}
	}
}
