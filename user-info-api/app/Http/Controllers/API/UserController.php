<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    public function profile(Request $request)
    {
        try {
            return response()->json([
                'status' => true,
                'user' => $request->user()
            ]);
        } catch (Exception $e) {
            Log::error('Profile fetch error: ' . $e->getMessage(), [
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return response()->json([
                'status' => false,
                'message' => 'An error occurred while fetching profile',
                'error' => config('app.debug') ? $e->getMessage() : 'Server error'
            ], 500);
        }
    }

    public function updateProfile(Request $request)
    {
        try {
            $user = $request->user();

            $validator = Validator::make($request->all(), [
                'name' => 'sometimes|string|max:255',
                'email' => 'sometimes|string|email|max:255|unique:users,email,' . $user->id,
                'current_password' => 'sometimes|required_with:password',
                'password' => 'sometimes|string|min:8|confirmed',
                'profile_photo' => 'sometimes|image|mimes:jpeg,png,jpg,gif|max:2048',
                'bio' => 'sometimes|nullable|string',
                'phone' => 'sometimes|nullable|string|max:15',
                'address' => 'sometimes|nullable|string',
                'hobbies' => 'sometimes|nullable|array',
                'hobbies.*' => 'string',
                'favorite_foods' => 'sometimes|nullable|array',
                'favorite_foods.*' => 'string',
                'height' => 'sometimes|nullable|numeric|min:0|max:300',
                'weight' => 'sometimes|nullable|numeric|min:0|max:500',
                'birthdate' => 'sometimes|nullable|date',
                'occupation' => 'sometimes|nullable|string|max:255',
                'social_media_links' => 'sometimes|nullable|array',
                'social_media_links.*' => 'string|url',
                'website' => 'sometimes|nullable|string|url|max:255',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Validation error',
                    'errors' => $validator->errors()
                ], 422);
            }

            if ($request->has('current_password')) {
                if (!Hash::check($request->current_password, $user->password)) {
                    return response()->json([
                        'status' => false,
                        'message' => 'Current password is incorrect'
                    ], 400);
                }
            }

            if ($request->has('name')) {
                $user->name = $request->name;
            }

            if ($request->has('email')) {
                $user->email = $request->email;
            }

            if ($request->has('password')) {
                $user->password = Hash::make($request->password);
            }

            $profileFields = [
                'bio',
                'phone',
                'address',
                'hobbies',
                'favorite_foods',
                'height',
                'weight',
                'birthdate',
                'occupation',
                'social_media_links',
                'website'
            ];

            foreach ($profileFields as $field) {
                if ($request->has($field)) {
                    $user->$field = $request->$field;
                }
            }

            if ($request->hasFile('profile_photo')) {
                try {
                    if ($user->profile_photo) {
                        Storage::disk('public')->delete($user->profile_photo);
                    }

                    $path = $request->file('profile_photo')->store('profile-photos', 'public');
                    $user->profile_photo = $path;
                } catch (Exception $e) {
                    Log::error('Profile photo upload error: ' . $e->getMessage(), [
                        'file' => $e->getFile(),
                        'line' => $e->getLine(),
                        'trace' => $e->getTraceAsString()
                    ]);
                    
                    return response()->json([
                        'status' => false,
                        'message' => 'An error occurred while uploading profile photo',
                        'error' => config('app.debug') ? $e->getMessage() : 'Server error'
                    ], 500);
                }
            }

            $user->save();

            return response()->json([
                'status' => true,
                'message' => 'Profile updated successfully',
                'user' => $user
            ]);
        } catch (Exception $e) {
            Log::error('Profile update error: ' . $e->getMessage(), [
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return response()->json([
                'status' => false,
                'message' => 'An error occurred while updating profile',
                'error' => config('app.debug') ? $e->getMessage() : 'Server error'
            ], 500);
        }
    }

    public function index(Request $request)
    {
        try {
            $query = User::query();

            if ($request->has('search')) {
                $query->where('name', 'like', '%' . $request->search . '%');
            }

            $perPage = $request->per_page ?? 10;
            $users = $query->paginate($perPage);

            return response()->json([
                'status' => true,
                'data' => $users
            ]);
        } catch (Exception $e) {
            Log::error('User index error: ' . $e->getMessage(), [
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return response()->json([
                'status' => false,
                'message' => 'An error occurred while fetching users',
                'error' => config('app.debug') ? $e->getMessage() : 'Server error'
            ], 500);
        }
    }

    public function show($id)
    {
        try {
            $user = User::find($id);

            if (!$user) {
                return response()->json([
                    'status' => false,
                    'message' => 'User not found'
                ], 404);
            }

            return response()->json([
                'status' => true,
                'user' => $user
            ]);
        } catch (Exception $e) {
            Log::error('User show error: ' . $e->getMessage(), [
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString(),
                'user_id' => $id
            ]);
            
            return response()->json([
                'status' => false,
                'message' => 'An error occurred while fetching user details',
                'error' => config('app.debug') ? $e->getMessage() : 'Server error'
            ], 500);
        }
    }
}