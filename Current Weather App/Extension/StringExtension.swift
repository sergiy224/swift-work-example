//
//  StringExtension.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 6/23/22.
//

import Foundation

extension String {

        func unaccent() -> String {

            return self.folding(options: .diacriticInsensitive, locale: .current)

        }

    }
