<?php

namespace App\Http\Controllers;

use App\Models\Favorite;
use App\Models\Lesson;
use App\Models\Quiz;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class FavoriteController extends Controller
{
  public function toggle(Request $request)
{
    $request->validate([
        'id' => 'required|integer',
        'type' => 'required|string|in:lesson,quiz',
    ]);

    $userId = Auth::id();

    $model = $request->type === 'lesson'
        ? Lesson::class
        : Quiz::class;

    $favorite = Favorite::where('user_id', $userId)
        ->where('favorable_id', $request->id)
        ->where('favorable_type', $model)
        ->first();

    if ($favorite) {
        $favorite->delete();
        return response()->json([
            'message' => 'Removed from favorites',
            'is_favorite' => false
        ]);
    }

    Favorite::create([
        'user_id' => $userId,
        'favorable_id' => $request->id,
        'favorable_type' => $model,
    ]);

    return response()->json([
        'message' => 'Added to favorites',
        'is_favorite' => true
    ]);
}

public function index()
{
    $favorites = Favorite::where('user_id', Auth::id())->get();

    return response()->json($favorites);
}
public function isFavorite(Request $request)
{
    $exists = Favorite::where('user_id', Auth::id())
        ->where('favorable_id', $request->favorable_id)
        ->where('favorable_type', $request->favorable_type)
        ->exists();

    return response()->json(['is_favorite' => $exists]);
}
public function favoriteLessons()
{
    $favorites = Favorite::where('user_id', Auth::id())
        ->where('favorable_type', Lesson::class)
        ->with('favorable')
        ->get()
        ->pluck('favorable');

    return response()->json($favorites);
}
public function favoriteQuizzes()
{
    $favorites = Favorite::where('user_id', Auth::id())
        ->where('favorable_type', Quiz::class)
        ->with('favorable')
        ->get()
        ->pluck('favorable');

    return response()->json($favorites);
}
public function allFavorites()
{
    $favorites = Favorite::where('user_id', Auth::id())
        ->with('favorable')
        ->get()
        ->map(function ($fav) {
            return [
                'type' => class_basename($fav->favorable_type), 
                'data' => $fav->favorable
            ];
        });

    return response()->json($favorites);
}
public function remove(Request $request)
{
    $request->validate([
        'id' => 'required|integer',
        'type' => 'required|string|in:lesson,quiz',
    ]);

    $userId = Auth::id();

    $model = $request->type === 'lesson'
        ? Lesson::class
        : Quiz::class;

    $favorite = Favorite::where('user_id', $userId)
        ->where('favorable_id', $request->id)
        ->where('favorable_type', $model)
        ->first();

    if (!$favorite) {
        return response()->json([
            'message' => 'Item is not in favorites',
            'is_favorite' => false
        ]);
    }

    $favorite->delete();

    return response()->json([
        'message' => 'Removed from favorites',
        'is_favorite' => false
    ]);
}
    }
